import 'package:flutter/material.dart';
import '../constants.dart';
import '../util/task.dart';
import 'package:MDST_todo/util/box.dart';

class ArchivedTodoTile extends StatelessWidget {
  ArchivedTodoTile({
    this.task,
  });
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Box(
        color: Colors.grey.withOpacity(0.7),
        //elevation: 4.0,
        //shadowColor: Colors.black.withOpacity(0.5),
        alignment: Alignment.center,
        //border: Border.all(width: 1.0, color: kKliemannGelb),
        borderRadius: 15.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.category,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Text(
                ' + ',
                style: TextStyle(color: kKliemannGrau),
              ),
              Text(
                task.activity,
                style: TextStyle(fontSize: 20.0),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    task.subtitle,
                    style: TextStyle(color: kKliemannGrau, fontSize: 15.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Text(
                '${task.finishedTime.day}/${task.finishedTime.month}/${task.finishedTime.year}',
                style: TextStyle(
                  color: kKliemannGrau,
                  fontSize: 13.0,
                ),
              ),
              Text(
                ' - ',
                style: TextStyle(
                  color: kKliemannGrau,
                  fontSize: 13.0,
                ),
              ),
              Text(
                '${task.totalTime.inMinutes} min',
                style: TextStyle(
                  color: kKliemannGrau,
                  fontSize: 13.0,
                ),
              ),
            ],
          ),
        ));
  }
}
