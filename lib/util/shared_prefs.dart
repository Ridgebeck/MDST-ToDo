import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task.dart';
import '../constants.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;
  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  int getInt(String key) {
    return _sharedPrefs.getInt(key);
  }

  void setInt(String key, int value) async {
    await _sharedPrefs.setInt(key, value);
  }

  String getString(String key) {
    return _sharedPrefs.getString(key);
  }

  void setString(String key, String value) async {
    await _sharedPrefs.setString(key, value);
  }

  List<String> getStringList(String key) {
    return _sharedPrefs.getStringList(key);
  }

  void setStringList(String key, List<String> value) async {
    await _sharedPrefs.setStringList(key, value);
  }

  void clear() async {
    await _sharedPrefs.clear();
  }

  void removeTaskList(listType type) async {
    switch (type) {
      case listType.active:
        await _sharedPrefs.remove('activeTaskList');
        break;
      case listType.finished:
        await _sharedPrefs.remove('finishedTaskList');
        break;
      case listType.archived:
        await _sharedPrefs.remove('archivedTaskList');
        break;
    }
  }

  bool initDataHasChanged() {
    try {
      return _sharedPrefs.getString('_dataHasChanged') == 'true' ? true : false;
    } catch (e) {
      print(e);
      // return true if no value was found
      return true;
    }
  }

  DateTime initLastTimeUploaded() {
    try {
      return DateTime.parse(_sharedPrefs.getString('_lastTimeUploaded'));
    } catch (e) {
      //print('shared_prefs.initLastTimeUploaded() error: $e');
      // if no previous value can be found
      // return yesterday to trigger uploading
      DateTime now = DateTime.now();
      return DateTime(now.year, now.month, now.day - 1);
    }
  }

  Map<String, int> initUploadedCategoryMinutesMap() {
    //Map<String, dynamic> jsonMap = json.decode(entry);
    return {};
  }

  List<Task> initTaskListFromLocal(listType type) {
    List<Task> tempTaskList = [];
    // for debug resetting
    //clear();

    try {
      List<String> stringList = [];
      switch (type) {
        case listType.active:
          stringList = _sharedPrefs.getStringList('activeTaskList');
          break;
        case listType.finished:
          stringList = _sharedPrefs.getStringList('finishedTaskList');
          break;
        case listType.archived:
          stringList = _sharedPrefs.getStringList('archivedTaskList');
          break;
      }

      if (stringList != null) {
        for (String entry in stringList) {
          // decode Strings into json maps
          // TODO: error handling
          Map<String, dynamic> jsonMap = json.decode(entry);
          // create a Task object from data
          Task task = Task(category: jsonMap['category'], activity: jsonMap['activity']);
          task.subtitle = jsonMap['subtitle'];
          jsonMap['originalStartTime'] == null
              ? task.originalStartTime = null
              : task.originalStartTime = DateTime.parse(jsonMap['originalStartTime']);
          task.totalTime = Duration(seconds: jsonMap['totalTime']);
          jsonMap['lastStartTime'] == null
              ? task.lastStartTime = null
              : task.lastStartTime = DateTime.parse(jsonMap['lastStartTime']);
          jsonMap['finishedTime'] == null
              ? task.finishedTime = null
              : task.finishedTime = DateTime.parse(jsonMap['finishedTime']);
          task.isActive = jsonMap['isActive'];
          task.isDone = jsonMap['isDone'];
          // add Task object to temp list
          tempTaskList.add(task);
        }
      }
    } catch (e) {
      print(e);
    }
    //print('$type list length: ${tempTaskList.length}');
    return tempTaskList;
  }
}

final sharedPrefs = SharedPrefs();
