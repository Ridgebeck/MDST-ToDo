import 'package:flutter/material.dart';
import '../constants.dart';
import '../util/task.dart';
import 'package:MDST_todo/util/box.dart';

class TodoTile extends StatelessWidget {
  TodoTile({this.task, this.leading, this.trailing, this.bottom});

  //final TaskData taskData;
  final Task task;
  final Widget leading;
  final Widget trailing;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return Box(
        color: task.isActive ? kKliemannBlau.withOpacity(0.7) : kKliemannGrau.withOpacity(0.7),
        elevation: 0.0,
        alignment: Alignment.center,
        //border: Border.all(width: 1.0, color: Colors.white),
        borderRadius: 15.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leading,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          task.category,
                          style: TextStyle(fontSize: kEmojiTextSize),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            '+',
                            style: task.isActive ? kTitleStyleActive : kTitleStyle,
                          ),
                        ),
                        Text(
                          task.activity,
                          style: TextStyle(fontSize: kEmojiTextSize),
                        ),
                      ]),
                      SizedBox(height: 10.0),
                      Text(
                        task.subtitle,
                        style: task.isActive ? kSubtitleStyleActive : kSubtitleStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      bottom,
                    ],
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ));
  }
}
