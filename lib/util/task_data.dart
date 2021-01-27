import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'task.dart';
import 'dart:collection';
import '../constants.dart';
import 'shared_prefs.dart';

class TaskData extends ChangeNotifier {
  bool _inReorder = false;
  List<Task> _activeTasks = sharedPrefs.initTaskListFromLocal(listType.active);
  List<Task> _finishedTasks = sharedPrefs.initTaskListFromLocal(listType.finished);
  List<Task> _archivedTasks = sharedPrefs.initTaskListFromLocal(listType.archived);

  void archiveOldTasks() {
    DateTime now = DateTime.now();
    DateTime dateToday = DateTime(
      now.year,
      now.month,
      now.day,
      //now.hour,
      //now.minute,
    );
    print(dateToday);

    List<Task> toRemove = [];
    for (Task task in _finishedTasks) {
      //print(task.originalStartTime);

      DateTime taskFinishedDay = DateTime(
        task.finishedTime.year,
        task.finishedTime.month,
        task.finishedTime.day,
        //task.finishedTime.hour,
        //task.finishedTime.minute,
      );

      if (taskFinishedDay.isBefore(dateToday)) {
        print('start time: ${task.originalStartTime}');
        // TODO: archive old tasks
        print('ARCHIVING!');
        // add task to remove list
        toRemove.add(task);
      }
    }
    // move all tasks which are on the remove list
    for (Task task in toRemove) {
      moveToArchivedList(task);
    }
    print('Archived List length: ${archivedTasks.length}');
  }

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
    task.finishedTime = DateTime.now();
    toggleActivity(task);
    _finishedTasks.add(task);
    _activeTasks.remove(task);
    saveTaskListToLocal(listType.finished);
    saveTaskListToLocal(listType.active);
    notifyListeners();
  }

  void moveToArchivedList(Task task) {
    _archivedTasks.add(task);
    _finishedTasks.remove(task);
    saveTaskListToLocal(listType.finished);
    saveTaskListToLocal(listType.archived);
    notifyListeners();
  }

  void saveTaskListToLocal(listType type) {
    // remove old data
    sharedPrefs.remove(type);
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
    notifyListeners();
  }

  void removeActiveTask(Task task) {
    _activeTasks.remove(task);
    saveTaskListToLocal(listType.active);
    notifyListeners();
  }

  void removeFinishedTask(Task task) {
    _finishedTasks.remove(task);
    saveTaskListToLocal(listType.finished);
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

  int get activeTasksLength {
    return _activeTasks.length;
  }

  int get finishedTasksLength {
    return _finishedTasks.length;
  }

  int get archivedTasksLength {
    return _archivedTasks.length;
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
