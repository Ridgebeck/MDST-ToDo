import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task.dart';

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

  void remove(bool finished) async {
    if (finished) {
      await _sharedPrefs.remove('finishedTaskList');
    } else {
      await _sharedPrefs.remove('activeTaskList');
    }
  }

  List<Task> initTaskListFromLocal(bool finished) {
    List<Task> tempTaskList = [];
    // for debug resetting
    //clear();

    try {
      List<String> stringList = finished
          ? sharedPrefs.getStringList('finishedTaskList')
          : sharedPrefs.getStringList('activeTaskList');
      if (stringList != null) {
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
          // add Task object to temp list
          tempTaskList.add(task);
        }
      }
    } catch (e) {
      print(e);
    }
    print('task list length: ${tempTaskList.length}');
    return tempTaskList;
  }
}

final sharedPrefs = SharedPrefs();
