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
      now.hour,
      now.minute,
    );
    print(dateToday);

    List<Task> toRemove = [];
    for (Task task in _finishedTasks) {
      print(task.activity);
      print(task.category);
      print(task.originalStartTime);

      DateTime taskStartDay = DateTime(
        task.originalStartTime.year,
        task.originalStartTime.month,
        task.originalStartTime.day,
        task.originalStartTime.hour,
        task.originalStartTime.minute,
      );

      if (taskStartDay.isBefore(dateToday)) {
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
  }

  void printTest() {
    print('10s tick');
    print('archived length: ${_archivedTasks.length}');
    //print('current task date: $_currentTasksDate');
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

  // void readTaskListFromLocal(listType type) {
  //   List<String> stringList = [];
  //   try {
  //
  //     // save list of Strings / json maps to local storage
  //     switch (type) {
  //       case listType.active:
  //         sharedPrefs.getStringList('activeTaskList');
  //         break;
  //       case listType.finished:
  //         sharedPrefs.getStringList('finishedTaskList');
  //         break;
  //       case listType.archived:
  //         sharedPrefs.getStringList('archivedTaskList');
  //         break;
  //     }
  //
  //     if (stringList != null) {
  //       // delete current list to replace with local values
  //       switch (type) {
  //         case listType.active:
  //           _activeTasks.clear();
  //           break;
  //         case listType.finished:
  //           _finishedTasks.clear();
  //           break;
  //         case listType.archived:
  //           _archivedTasks.clear();
  //           break;
  //       }
  //
  //       // convert String list to task object
  //       for (String entry in stringList) {
  //         // decode Strings into json maps
  //         Map<String, dynamic> jsonMap = json.decode(entry);
  //         // create a Task object from data
  //         Task task = Task(category: jsonMap['category'], activity: jsonMap['activity']);
  //         task.subtitle = jsonMap['subtitle'];
  //         task.totalTime = Duration(seconds: jsonMap['totalTime']);
  //         jsonMap['originalStartTime'] == null
  //             ? task.originalStartTime = null
  //             : task.originalStartTime = DateTime.parse(jsonMap['originalStartTime']);
  //         jsonMap['lastStartTime'] == null
  //             ? task.lastStartTime = null
  //             : task.lastStartTime = DateTime.parse(jsonMap['lastStartTime']);
  //         task.isActive = jsonMap['isActive'];
  //         task.isDone = jsonMap['isDone'];
  //
  //         // add Task object to corresponding task list
  //         switch (type) {
  //           case listType.active:
  //             _activeTasks.add(task);
  //             break;
  //           case listType.finished:
  //             _finishedTasks.add(task);
  //             break;
  //           case listType.archived:
  //             _archivedTasks.add(task);
  //             break;
  //         }
  //
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   // update UI
  //   notifyListeners();
  // }

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
