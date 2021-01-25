import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'task.dart';
import 'dart:collection';
import '../constants.dart';
import 'shared_prefs.dart';

class TaskData extends ChangeNotifier {
  bool _inReorder = false;
  List<Task> _activeTasks = sharedPrefs.initTaskListFromLocal(false);
  List<Task> _finishedTasks = sharedPrefs.initTaskListFromLocal(true);

  void updateTaskTime() {
    for (Task task in _activeTasks) {
      if (task.isActive) {
        // track time since last time it was activated
        DateTime now = DateTime.now();
        task.totalTime += now.difference(task.lastStartTime);
        task.lastStartTime = now;
      }
    }
  }

  static List<String> _categoryStringList = [
    '🏠',
    '🚿',
    '💡',
    '🔌',
    '🪑',
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
    '🆕',
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
    toggleActivity(task);
    _activeTasks.remove(task);
    _finishedTasks.add(task);
    saveTaskListToLocal(true);
    saveTaskListToLocal(false);
    notifyListeners();
  }

  void saveTaskListToLocal(bool finished) {
    // remove old data
    sharedPrefs.remove(finished);
    // define which list to save
    List<Task> taskList = finished ? _finishedTasks : _activeTasks;
    // create empty string list
    List<String> stringList = [];
    // save each task as JSON Map
    for (Task task in taskList) {
      Map<String, dynamic> taskJson = {
        'category': task.category,
        'activity': task.activity,
        'subtitle': task.subtitle,
        'totalTime': task.totalTime.inSeconds,
        'lastStartTime': task.lastStartTime == null ? null : task.lastStartTime.toIso8601String(),
        'isActive': task.isActive,
        'isDone': task.isDone,
      };
      // add task json to String list
      stringList.add(json.encode(taskJson));
    }
    try {
      // save list of Strings / json maps to local storage
      finished
          ? sharedPrefs.setStringList('finishedTaskList', stringList)
          : sharedPrefs.setStringList('activeTaskList', stringList);
    } catch (e) {
      print(e);
    }
  }

  void readTaskListFromLocal(bool finished) {
    // TODO: add try catch
    List<String> stringList = [];
    stringList = finished
        ? sharedPrefs.getStringList('finishedTaskList')
        : sharedPrefs.getStringList('activeTaskList');
    if (stringList != null) {
      // delete current list to replace with local values
      finished ? _finishedTasks.clear() : _activeTasks.clear();

      for (String entry in stringList) {
        // decode Strings into json maps
        Map<String, dynamic> jsonMap = json.decode(entry);
        // create a Task object from data
        Task task = Task(category: jsonMap['category'], activity: jsonMap['activity']);
        task.subtitle = jsonMap['subtitle'];
        task.totalTime = Duration(seconds: jsonMap['totalTime']);
        jsonMap['lastStartTime'] == null
            ? task.lastStartTime = null
            : task.lastStartTime = DateTime.parse(jsonMap['lastStartTime']);
        task.isActive = jsonMap['isActive'];
        task.isDone = jsonMap['isDone'];
        // add Task object to corresponding task list
        finished ? _finishedTasks.add(task) : _activeTasks.add(task);
      }
    }
    // update UI
    notifyListeners();
  }

  void addTask({int emojiIndex1, int emojiIndex2, String subtitle}) {
    final task = Task(
        category: _categoryStringList[emojiIndex1],
        activity: _activityStringList[emojiIndex2],
        subtitle: subtitle);

    _activeTasks.add(task);
    saveTaskListToLocal(false);
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
    saveTaskListToLocal(false);
    notifyListeners();
  }

  void removeActiveTask(Task task) {
    _activeTasks.remove(task);
    saveTaskListToLocal(false);
    notifyListeners();
  }

  void removeFinishedTask(Task task) {
    _finishedTasks.remove(task);
    saveTaskListToLocal(true);
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

  // UnmodifiableListView<Text> get categoryEmojis {
  //   return UnmodifiableListView(_categoryEmojis);
  // }
  //
  // UnmodifiableListView<Text> get activityEmojis {
  //   return UnmodifiableListView(_activityEmojis);
  // }

  int get activeTasksLength {
    return _activeTasks.length;
  }

  int get finishedTasksLength {
    return _finishedTasks.length;
  }

  Map<String, int> get totalTime {
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

  Map<String, Duration> get topCategory {
    // create map with category emoji and time
    Map<String, Duration> categoryDuration = {};
    if (_activeTasks.length == 0 && _finishedTasks.length == 0) {
      return {'🤷‍♀': Duration(minutes: 0)};
    } else {
      for (Task task in _activeTasks) {
        if (categoryDuration.containsKey(task.category)) {
          categoryDuration[task.category] += task.totalTime;
        } else {
          categoryDuration[task.category] = task.totalTime;
        }
      }
      for (Task task in _finishedTasks) {
        if (categoryDuration.containsKey(task.category)) {
          categoryDuration[task.category] += task.totalTime;
        } else {
          categoryDuration[task.category] = task.totalTime;
        }
      }
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
  }

  Map<String, Duration> get topActivity {
    // create map with category emoji and time
    Map<String, Duration> activityDuration = {};
    if (_activeTasks.length == 0 && _finishedTasks.length == 0) {
      return {'🤷‍♂': Duration(minutes: 0)};
    } else {
      for (Task task in _activeTasks) {
        if (activityDuration.containsKey(task.activity)) {
          activityDuration[task.activity] += task.totalTime;
        } else {
          activityDuration[task.activity] = task.totalTime;
        }
      }
      for (Task task in _finishedTasks) {
        if (activityDuration.containsKey(task.activity)) {
          activityDuration[task.activity] += task.totalTime;
        } else {
          activityDuration[task.activity] = task.totalTime;
        }
      }
      Duration maxDuration = Duration(minutes: 0);
      String topEmoji;
      activityDuration.forEach((emoji, duration) {
        if (duration >= maxDuration) {
          topEmoji = emoji;
          maxDuration = duration;
        }
      });
      return {topEmoji: maxDuration};
    }
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

  bool get inReorder {
    return _inReorder;
  }
}
