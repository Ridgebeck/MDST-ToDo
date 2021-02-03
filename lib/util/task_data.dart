import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'task.dart';
import 'dart:collection';
import '../constants.dart';
import 'shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskData extends ChangeNotifier {
  int _pageIndex = 3;
  bool _newAppStart = true;
  bool _dataInitialized = sharedPrefs.initDataInitialized();
  bool isMDST = false;
  bool _inReorder = false;
  bool _communitySwitch = false;
  List<Task> _activeTasks = sharedPrefs.initTaskListFromLocal(listType.active);
  List<Task> _finishedTasks = sharedPrefs.initTaskListFromLocal(listType.finished);
  List<Task> _archivedTasks = sharedPrefs.initTaskListFromLocal(listType.archived);

  bool _dataHasChanged = sharedPrefs.initDataHasChanged();
  DateTime _lastTimeUploaded = sharedPrefs.initLastTimeUploaded();
  DateTime _lastTimeDownloaded = sharedPrefs.initLastTimeDownloaded();
  DateTime _lastTimerUpdate = DateTime.now();

  bool _communityDataReceived = false;
  bool _communityDataStale = true;
  int _communityActiveTasksToday = 0;
  int _communityFinishedTasksToday = 0;
  int _communityTotalHours = 0;
  int _communityTotalMinutes = 0;
  List<dynamic> _topCommunityCategories = []; // TODO: REMOVE
  List<dynamic> _topCommunityActivities = []; // TODO: REMOVE

  int _uploadedTotalMinutes = sharedPrefs.getInt('_uploadedTotalMinutes') ?? 0;
  int _uploadedActiveTasks = sharedPrefs.getInt('_uploadedActiveTasks') ?? 0;
  int _uploadedFinishedTasks = sharedPrefs.getInt('_uploadedFinishedTasks') ?? 0;
  Map<String, dynamic> _uploadedCategoryMinutesMap =
      sharedPrefs.getString('_uploadedCategoryMinutesMap') == null
          ? {}
          : json.decode(sharedPrefs.getString('_uploadedCategoryMinutesMap'));
  Map<String, dynamic> _uploadedActivityMinutesMap =
      sharedPrefs.getString('_uploadedActivityMinutesMap') == null
          ? {}
          : json.decode(sharedPrefs.getString('_uploadedActivityMinutesMap'));

  void setDataHasChanged(bool value) {
    _dataHasChanged = value;
    // save boolean to local memory
    try {
      sharedPrefs.setString('_dataHasChanged', value.toString());
    } catch (e) {
      print(e);
    }
  }

  void saveLastTimeUploaded(DateTime dateTime) {
    _lastTimeUploaded = dateTime;
    // save boolean to local memory
    try {
      sharedPrefs.setString('_lastTimeUploaded', dateTime.toIso8601String());
      //print('saved last time to local memory');
    } catch (e) {
      print(e);
    }
  }

  void saveLastTimeDownloaded(DateTime dateTime) {
    _lastTimeDownloaded = dateTime;
    // save boolean to local memory
    try {
      sharedPrefs.setString('_lastTimeDownloaded', dateTime.toIso8601String());
      //print('saved last time to local memory');
    } catch (e) {
      print(e);
    }
  }

  void resetAllDailyData() {
    _uploadedTotalMinutes = 0;
    _uploadedActiveTasks = 0;
    _uploadedFinishedTasks = 0;
    _uploadedCategoryMinutesMap = {};
    _uploadedActivityMinutesMap = {};
    saveUploadedDataLocally();
  }

  void saveUploadedDataLocally() {
    try {
      sharedPrefs.setInt('_uploadedTotalMinutes', _uploadedTotalMinutes);
      sharedPrefs.setInt('_uploadedActiveTasks', _uploadedActiveTasks);
      sharedPrefs.setInt('_uploadedFinishedTasks', _uploadedFinishedTasks);
      sharedPrefs.setString(
          '_uploadedCategoryMinutesMap', json.encode(_uploadedCategoryMinutesMap));
      sharedPrefs.setString(
          '_uploadedActivityMinutesMap', json.encode(_uploadedActivityMinutesMap));

      //print('saved uploaded data to local memory');
    } catch (e) {
      print(e);
    }
  }

  void uploadData(int minutes) async {
    DateTime now = DateTime.now();
    Duration timeSinceLastUpload = now.difference(_lastTimeUploaded);

    print('data has changed: $_dataHasChanged');
    //print('last time uploaded: $_lastTimeUploaded');
    print('DIFFERENCE: ${timeSinceLastUpload.inMinutes}');
    print('Data initialized: $_dataInitialized');

    // only upload data during MDST
    if (now.isAfter(DateTime.parse(mdstStart)) && now.isBefore(DateTime.parse(mdstEnd))) {
      // only upload every 10 minutes
      if (timeSinceLastUpload.inMinutes >= minutes) {
        // only upload if anything has changed or first time on MDST
        if (_dataHasChanged == true || _dataInitialized == false) {
          //print('Data has changed. Uploading data...');
          uploadUserData();

          // // check if last upload was before today
          // DateTime dayOfLastUpload = DateTime(
          //   _lastTimeUploaded.year,
          //   _lastTimeUploaded.month,
          //   _lastTimeUploaded.day,
          // );
          // DateTime dayRightNow = DateTime(
          //   now.year,
          //   now.month,
          //   now.day,
          // );
          // if (dayOfLastUpload.isBefore(dayRightNow)) {
          //   // reset all memorized data
          //   //resetAllDailyData();
          //   // TODO: handle data that gets accumulated over multiple days
          //
          //   // change stream to data of new day
          //   //firebaseDataStream();
          // }

          uploadAggregatedData();

          saveLastTimeUploaded(DateTime.now());
          setDataHasChanged(false);

          if (_dataInitialized == false) {
            _dataInitialized = true;
            sharedPrefs.setString('_dataInitialized', 'true');
          }
        }
      }
    }
  }

  void stopActiveTasksAtEnd() {
    if (DateTime.now().isAfter(DateTime.parse(mdstEnd))) {
      for (Task task in _activeTasks) {
        task.isActive = false;
      }
    }
  }

  void archiveOldTasks() {
    DateTime now = DateTime.now();
    DateTime dateToday = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );

    List<Task> toRemove = [];
    for (Task task in _finishedTasks) {
      //print('finished task datetime check');
      //print(task.finishedTime);
      DateTime taskFinishedDay = DateTime(
        task.finishedTime.year,
        task.finishedTime.month,
        task.finishedTime.day,
        //task.finishedTime.hour,
        //task.finishedTime.minute,
      );

      if (taskFinishedDay.isBefore(dateToday)) {
        // add task to a remove list
        toRemove.add(task);
      }
    }

    //move all tasks which are on the remove list
    for (Task task in toRemove) {
      //print('ARCHIVING!');
      moveToArchivedList(task);
    }
  }

  void updateTaskTime() {
    for (Task task in _activeTasks) {
      if (task.isActive) {
        // track time since last time it was activated
        DateTime now = DateTime.now();
        task.totalTime += now.difference(task.lastStartTime);
        task.lastStartTime = now;
        setDataHasChanged(true);
        //print('Update $now');

        if (now.difference(_lastTimerUpdate).inSeconds > 5) {
          //print('TIME DIFFERENCE: ${now.difference(_lastTimerUpdate)}');
          _lastTimerUpdate = DateTime.now();
          notifyListeners();
        }
      }
    }
  }

  static List<String> _categoryStringList = [
    '🏠',
    '🚿',
    '💡',
    '🔌',
    '🪑',
    '👕',
    '💻',
    '🚗',
    '🚲',
    '🏍',
    '⛵',
    '🌳',
    '🌻',
    '🐕',
    '⚽',
    '🎵',
  ];

  static List<String> _activityStringList = [
    '🛠',
    '🧹',
    '✂',
    '🗑',
    '🩹',
    '💰',
    '🎨',
    '🛒',
    '📦',
    '🎁',
  ];

  List<Text> createCategoryEmojis() {
    return createTextWidgetList(_categoryStringList);
  }

  List<Text> createActivityEmojis() {
    return createTextWidgetList(_activityStringList);
  }

  List<Text> createTextWidgetList(List<String> stringList) {
    List<Text> textList = [];
    for (String entry in stringList) {
      textList.add(
        Text(
          entry,
          style: TextStyle(
            fontSize: kEmojiTextSize,
          ),
        ),
      );
    }
    return textList;
  }

  void moveToFinishedList(Task task) {
    task.finishedTime = DateTime.now();
    toggleActivity(task);
    _finishedTasks.add(task);
    _activeTasks.remove(task);
    saveTaskListToLocal(listType.finished);
    saveTaskListToLocal(listType.active);
    setDataHasChanged(true);
    notifyListeners();
  }

  void moveToArchivedList(Task task) {
    _archivedTasks.add(task);
    _finishedTasks.remove(task);
    saveTaskListToLocal(listType.finished);
    saveTaskListToLocal(listType.archived);
    setDataHasChanged(true);
    notifyListeners();
  }

  void saveTaskListToLocal(listType type) {
    // remove old data
    sharedPrefs.removeTaskList(type);
    // define which list to save
    List<Task> taskList = [];
    switch (type) {
      case listType.active:
        taskList = _activeTasks;
        break;
      case listType.finished:
        taskList = _finishedTasks;
        break;
      case listType.archived:
        taskList = _archivedTasks;
        break;
    }

    // create empty string list
    List<String> stringList = [];
    // save each task as JSON Map
    for (Task task in taskList) {
      Map<String, dynamic> taskJson = {
        'category': task.category,
        'activity': task.activity,
        'subtitle': task.subtitle,
        'totalTime': task.totalTime.inSeconds,
        'originalStartTime':
            task.originalStartTime == null ? null : task.originalStartTime.toIso8601String(),
        'lastStartTime': task.lastStartTime == null ? null : task.lastStartTime.toIso8601String(),
        'finishedTime': task.finishedTime == null ? null : task.finishedTime.toIso8601String(),
        'isActive': task.isActive,
        'isDone': task.isDone,
      };
      // add task json to String list
      stringList.add(json.encode(taskJson));
    }
    try {
      // save list of Strings / json maps to local storage
      switch (type) {
        case listType.active:
          sharedPrefs.setStringList('activeTaskList', stringList);
          break;
        case listType.finished:
          sharedPrefs.setStringList('finishedTaskList', stringList);
          break;
        case listType.archived:
          sharedPrefs.setStringList('archivedTaskList', stringList);
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  void addTask({int emojiIndex1, int emojiIndex2, String subtitle}) {
    final task = Task(
      category: _categoryStringList[emojiIndex1],
      activity: _activityStringList[emojiIndex2],
      subtitle: subtitle,
      originalStartTime: DateTime.now(),
    );

    _activeTasks.add(task);
    saveTaskListToLocal(listType.active);
    setDataHasChanged(true);
    notifyListeners();
  }

  void toggleActivity(Task task) {
    if (task.isActive) {
      // track time since last time it was activated
      Duration difference = DateTime.now().difference(task.lastStartTime);
      task.totalTime += difference;
      task.infoText = playMessage;
    } else {
      // set new start time for task
      task.lastStartTime = DateTime.now();
      task.infoText = slideMessage;
    }
    // toggle active property
    task.isActive = !task.isActive;
    // save active tasks to local
    saveTaskListToLocal(listType.active);
    setDataHasChanged(true);
    notifyListeners();
  }

  void removeActiveTask(Task task) {
    _activeTasks.remove(task);
    saveTaskListToLocal(listType.active);
    setDataHasChanged(true);
    notifyListeners();
  }

  void removeFinishedTask(Task task) {
    _finishedTasks.remove(task);
    saveTaskListToLocal(listType.finished);
    setDataHasChanged(true);
    notifyListeners();
  }

  void setInReorder(bool value) {
    _inReorder = value;
    notifyListeners();
  }

  void onReorderFinished(List<Task> newItems, ScrollController scrollController) {
    //(List<Language> newItems) {
    scrollController.jumpTo(scrollController.offset);
    _inReorder = false;

    _activeTasks
      ..clear()
      ..addAll(newItems);
    notifyListeners();
  }

  UnmodifiableListView<Task> get finishedTasks {
    return UnmodifiableListView(_finishedTasks);
  }

  UnmodifiableListView<Task> get activeTasks {
    return UnmodifiableListView(_activeTasks);
  }

  UnmodifiableListView<Task> get archivedTasks {
    return UnmodifiableListView(_archivedTasks);
  }

  // UnmodifiableListView<Text> get categoryEmojis {
  //   return UnmodifiableListView(_categoryEmojis);
  // }
  //
  // UnmodifiableListView<Text> get activityEmojis {
  //   return UnmodifiableListView(_activityEmojis);
  // }

  void setPageIndex(int index) {
    _pageIndex = index;
  }

  int get activeTasksLength {
    return _activeTasks.length;
  }

  int get finishedTasksLength {
    return _finishedTasks.length;
  }

  int get archivedTasksLength {
    return _archivedTasks.length;
  }

  Map<String, int> get myTotalTimeToday {
    Duration sumDuration = Duration(minutes: 0);
    for (Task task in _activeTasks) {
      sumDuration += task.totalTime;
    }
    for (Task task in _finishedTasks) {
      sumDuration += task.totalTime;
    }
    int hours = sumDuration.inHours;
    int minutes = sumDuration.inMinutes - hours * 60;
    return {'hours': hours, 'minutes': minutes};
  }

  Map<String, Duration> createEmojiDurationMap(entryType type) {
    // create map with category emoji and time
    Map<String, Duration> categoryDuration = {};
    if (_activeTasks.length == 0 && _finishedTasks.length == 0) {
      if (type == entryType.category) {
        return {'🤷‍♀': Duration(minutes: 0)};
      } else {
        return {'🤷‍♂': Duration(minutes: 0)};
      }
    } else {
      for (Task task in _activeTasks) {
        if (categoryDuration
            .containsKey(type == entryType.category ? task.category : task.activity)) {
          categoryDuration[type == entryType.category ? task.category : task.activity] +=
              task.totalTime;
        } else {
          categoryDuration[type == entryType.category ? task.category : task.activity] =
              task.totalTime;
        }
      }
      for (Task task in _finishedTasks) {
        if (categoryDuration
            .containsKey(type == entryType.category ? task.category : task.activity)) {
          categoryDuration[type == entryType.category ? task.category : task.activity] +=
              task.totalTime;
        } else {
          categoryDuration[type == entryType.category ? task.category : task.activity] =
              task.totalTime;
        }
      }
      return categoryDuration;
    }
  }

  Map<String, Duration> topEmojiAndTime(entryType type) {
    Map<String, Duration> categoryDuration = createEmojiDurationMap(type);
    Duration maxDuration = Duration(minutes: 0);
    String topEmoji;
    categoryDuration.forEach((emoji, duration) {
      if (duration >= maxDuration) {
        topEmoji = emoji;
        maxDuration = duration;
      }
    });
    return {topEmoji: maxDuration};
  }

  double get percentageDone {
    if (_finishedTasks.length + _activeTasks.length == 0) {
      return 0;
    } else {
      return 100 * _finishedTasks.length / (_finishedTasks.length + _activeTasks.length);
    }
  }

  double get ratioDone {
    if (_finishedTasks.length + _activeTasks.length == 0) {
      return 0;
    } else {
      return _finishedTasks.length / (_finishedTasks.length + _activeTasks.length);
    }
  }

  double get communityRatioDone {
    if (_communityFinishedTasksToday + _communityActiveTasksToday == 0) {
      return 0;
    } else {
      return _communityFinishedTasksToday /
          (_communityFinishedTasksToday + _communityActiveTasksToday);
    }
  }

  bool get inReorder {
    return _inReorder;
  }

  bool get communitySwitch {
    return _communitySwitch;
  }

  int get communityActiveTasksToday {
    return _communityActiveTasksToday;
  }

  int get communityFinishedTasksToday {
    return _communityFinishedTasksToday;
  }

  int get communityTotalHours {
    return _communityTotalHours;
  }

  int get communityTotalMinutes {
    return _communityTotalMinutes;
  }

  List<dynamic> get topCommunityCategories {
    return _topCommunityCategories;
  }

  List<dynamic> get topCommunityActivities {
    return _topCommunityActivities;
  }

  bool get communityDataReceived {
    return _communityDataReceived;
  }

  void setCommunitySwitch(bool value) {
    _communitySwitch = value;
    notifyListeners();
  }

  void getCommunityData(int minutes) {
    DateTime now = DateTime.now();
    Duration timeSinceLastDownload = now.difference(_lastTimeDownloaded);

    print('last time downloaded: $_lastTimeDownloaded');
    print('DOWNLOAD DIFFERENCE: ${timeSinceLastDownload.inMinutes}');
    print('page index: $_pageIndex');

    // only download data during MDST
    if (now.isAfter(DateTime.parse(mdstStart))) {
      // reduce frequency after MDST
      if (now.isAfter(DateTime.parse(mdstEnd))) {
        minutes = 120;
      }
      // only download every x minutes
      if ((timeSinceLastDownload.inMinutes >= minutes && _pageIndex == 3) || _newAppStart) {
        _newAppStart = false;
        final _firestore = FirebaseFirestore.instance;
        DateTime mdstDay = DateTime.parse(mdstStart);
        _firestore
            .collection('dailyCommunityStats')
            .where('date', isEqualTo: mdstDay)
            .get()
            .then((querySnapshot) {
          if (querySnapshot.docs == null) {
            //print('No daily snapshot found.');
            _communityDataReceived = false;
          } else {
            if (querySnapshot.docs.length != 1) {
              //print('Error - more than one document or no document found!');
              _communityDataReceived = false;
            } else {
              try {
                var data = querySnapshot.docs.last.data();

                print('DATA: ${querySnapshot.docs.last.data()}');
                print('METADATA is from cache: ${querySnapshot.metadata.isFromCache}');

                _communityActiveTasksToday = data['activeTasks'] ?? 0;
                _communityFinishedTasksToday = data['finishedTasks'] ?? 0;
                int totalMinutes = data['totalMinutes'] ?? 0;
                _communityTotalHours = (totalMinutes ~/ 60);
                _communityTotalMinutes = totalMinutes - _communityTotalHours * 60;

                Map<String, dynamic> categoryMinutesUnsorted = data['categoryMinutesMap'] ?? [];
                Map<String, dynamic> activityMinutesUnsorted = data['activityMinutesMap'] ?? [];

                List<String> sortedCategoryEmojis = categoryMinutesUnsorted.keys
                    .toList(growable: false)
                      ..sort((k1, k2) =>
                          categoryMinutesUnsorted[k2].compareTo(categoryMinutesUnsorted[k1]));

                List<String> sortedActivityEmojis = activityMinutesUnsorted.keys
                    .toList(growable: false)
                      ..sort((k1, k2) =>
                          activityMinutesUnsorted[k2].compareTo(activityMinutesUnsorted[k1]));

                List<Map<String, dynamic>> topCategoryList = [];
                for (String emoji in sortedCategoryEmojis) {
                  Map<String, dynamic> itemMap = {
                    'emoji': emoji,
                    'minutes': categoryMinutesUnsorted[emoji],
                  };
                  topCategoryList.add(itemMap);
                }

                List<Map<String, dynamic>> topActivityList = [];
                for (String emoji in sortedActivityEmojis) {
                  Map<String, dynamic> itemMap = {
                    'emoji': emoji,
                    'minutes': activityMinutesUnsorted[emoji],
                  };
                  topActivityList.add(itemMap);
                }

                _topCommunityCategories =
                    topCategoryList.sublist(0, min(3, topCategoryList.length)) ?? [];
                _topCommunityActivities =
                    topActivityList.sublist(0, min(3, topActivityList.length)) ?? [];

                //print(_topCommunityCategories[0]['emoji']);
                _communityDataReceived = true;
                _communityDataStale = querySnapshot.metadata.isFromCache;
                saveLastTimeDownloaded(DateTime.now());
              } catch (e) {
                print('FIRESTORE ERROR!');
                print(e);
                _communityDataReceived = false;
              }

              notifyListeners();
            }
          }
        });
      }
    }
  }

  void uploadUserData() async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    UserCredential userCredential = await _auth.signInAnonymously();
    String uid = userCredential.user.uid;

    Map<String, int> timePerCategory = {};
    Map<String, int> timePerActivity = {};
    List<dynamic> activeTaskList = [];

    for (Task task in _activeTasks) {
      timePerCategory.containsKey(task.category)
          ? timePerCategory[task.category] += task.totalTime.inMinutes
          : timePerCategory[task.category] = task.totalTime.inMinutes;
      timePerActivity.containsKey(task.activity)
          ? timePerActivity[task.activity] += task.totalTime.inMinutes
          : timePerActivity[task.activity] = task.totalTime.inMinutes;

      activeTaskList.add({
        'category': task.category,
        'activity': task.activity,
        'subtitle': task.subtitle,
        'infoText': task.infoText,
        'totalTime in minutes': task.totalTime.inMinutes,
        'originalStartTime': task.originalStartTime,
        'lastStartTime': task.lastStartTime,
        'finishedTime': task.finishedTime,
        'isActive': task.isActive,
        'isActive': task.isActive,
        'isDone': task.isDone,
      });
    }
    List<dynamic> finishedTaskList = [];
    for (Task task in _finishedTasks) {
      timePerCategory.containsKey(task.category)
          ? timePerCategory[task.category] += task.totalTime.inMinutes ?? 0
          : timePerCategory[task.category] = task.totalTime.inMinutes ?? 0;
      timePerActivity.containsKey(task.activity)
          ? timePerActivity[task.activity] += task.totalTime.inMinutes ?? 0
          : timePerActivity[task.activity] = task.totalTime.inMinutes ?? 0;

      finishedTaskList.add({
        'category': task.category,
        'activity': task.activity,
        'subtitle': task.subtitle,
        'infoText': task.infoText,
        'totalTime in minutes': task.totalTime.inMinutes,
        'originalStartTime': task.originalStartTime,
        'lastStartTime': task.lastStartTime,
        'finishedTime': task.finishedTime,
        'isActive': task.isActive,
        'isActive': task.isActive,
        'isDone': task.isDone,
      });
    }

    // create document title from current date
    String docName = createDateDocName();
    DateTime now = DateTime.now();

    await _firestore.collection('UID').doc(uid).collection('dailyStats').doc(docName).set({
      'lastUpdated': now,
      'activeTaskList': activeTaskList,
      'finishedTaskList': finishedTaskList,
      'finishedTasks': finishedTasksLength,
      'activeTasks': activeTasksLength,
      'archivedTasks': archivedTasksLength,
      'timePerCategory': timePerCategory,
      'timePerActivity': timePerActivity,
      'totalTimeInMinutes': myTotalMinutesToday(),
      'day': DateTime(now.year, now.month, now.day),
    });
  }

  void uploadAggregatedData() async {
    final _firestore = FirebaseFirestore.instance;
    String docName = createDateDocName();
    DateTime now = DateTime.now();

    Map<String, int> categoryMinutesMap = {};
    Map<String, int> activityMinutesMap = {};

    //_uploadedCategoryMinutesMap

    // convert Duration values to int values
    createEmojiDurationMap(entryType.category).forEach((key, value) {
      if (key != '🤷‍♀') {
        categoryMinutesMap[key] = value.inMinutes;
      }
    });
    createEmojiDurationMap(entryType.activity).forEach((key, value) {
      if (key != '🤷‍♂') {
        activityMinutesMap[key] = value.inMinutes;
      }
    });

    Map<String, FieldValue> categoryFieldValueMap = {};
    Map<String, FieldValue> activityFieldValueMap = {};

    _uploadedCategoryMinutesMap.forEach((emoji, minutes) {
      if (categoryMinutesMap.containsKey(emoji) == false) {
        categoryFieldValueMap[emoji] = FieldValue.increment(-minutes);
        _uploadedCategoryMinutesMap[emoji] = 0;
      }
    });
    _uploadedActivityMinutesMap.forEach((emoji, minutes) {
      if (activityMinutesMap.containsKey(emoji) == false) {
        activityFieldValueMap[emoji] = FieldValue.increment(-minutes);
        _uploadedActivityMinutesMap[emoji] = 0;
      }
    });

    categoryMinutesMap.forEach((emoji, minutes) {
      categoryFieldValueMap[emoji] =
          FieldValue.increment(minutes - (_uploadedCategoryMinutesMap[emoji] ?? 0));
      _uploadedCategoryMinutesMap[emoji] = categoryMinutesMap[emoji];
    });

    activityMinutesMap.forEach((emoji, minutes) {
      activityFieldValueMap[emoji] =
          FieldValue.increment(minutes - (_uploadedActivityMinutesMap[emoji] ?? 0));
      _uploadedActivityMinutesMap[emoji] = activityMinutesMap[emoji];
    });

    int totalMinutes = myTotalMinutesToday();

    await _firestore.collection('dailyCommunityStats').doc(docName).set(
      {
        'date': DateTime(now.year, now.month, now.day),
        'totalMinutes': FieldValue.increment(totalMinutes - _uploadedTotalMinutes),
        'activeTasks': FieldValue.increment(activeTasksLength - _uploadedActiveTasks),
        'finishedTasks': FieldValue.increment(finishedTasksLength - _uploadedFinishedTasks),
        'categoryMinutesMap': categoryFieldValueMap,
        'activityMinutesMap': activityFieldValueMap,
      },
      SetOptions(merge: true),
    );

    _uploadedTotalMinutes = totalMinutes;
    _uploadedActiveTasks = activeTasksLength;
    _uploadedFinishedTasks = finishedTasksLength;
    saveUploadedDataLocally();

    // if (communityDataReceived == false) {
    //   firebaseDataStream();
    // }
  }

  String createDateDocName() {
    DateTime now = DateTime.now();
    String docName = now.year.toString() +
        '_' +
        now.month.toString().padLeft(2, '0') +
        '_' +
        now.day.toString().padLeft(2, '0');
    return docName;
  }

  int myTotalMinutesToday() {
    return myTotalTimeToday['hours'] * 60 + myTotalTimeToday['minutes'];
  }
}
