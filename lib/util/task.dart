import 'package:flutter/material.dart';

class Task {
  final String category;
  final String activity;
  String subtitle;
  Duration totalTime;
  DateTime lastStartTime;
  bool isActive = false;
  bool isDone = false;
  Task({
    @required this.category,
    @required this.activity,
    this.subtitle,
    this.totalTime = const Duration(minutes: 0),
    this.lastStartTime,
  });
}
