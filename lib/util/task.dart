import '../constants.dart';
import 'package:flutter/material.dart';

class Task {
  final String category;
  final String activity;
  String subtitle;
  String infoText;
  Duration totalTime;
  DateTime originalStartTime;
  DateTime lastStartTime;
  DateTime finishedTime;
  bool isActive = false;
  bool isDone = false;
  Task({
    @required this.category,
    @required this.activity,
    this.subtitle,
    this.infoText = playMessage,
    this.totalTime = const Duration(minutes: 0),
    this.originalStartTime,
    this.finishedTime,
    this.lastStartTime,
  });
}
