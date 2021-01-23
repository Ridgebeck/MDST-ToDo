import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/task_data.dart';
import '../constants.dart';

class FinishedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        separatorBuilder: (context, index) => SizedBox(
          height: 10.0,
        ),
        itemBuilder: (context, index) {
          final finishedTask = taskData.finishedTasks[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: ListTile(
              tileColor: Colors.grey[200].withOpacity(0.9),
              contentPadding: EdgeInsets.all(20.0),
              leading: Icon(
                Icons.check,
                size: 35.0,
                color: kKliemannGrau,
              ),
              title: Text(
                finishedTask.category + ' + ' + finishedTask.activity,
                style: kTitleStyle,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: kSubtitlePadding),
                child: Text(
                  finishedTask.subtitle,
                  style: kSubtitleStyle,
                ),
              ),
              trailing: Text(
                //'51 mins',
                '${finishedTask.totalTime.inSeconds} Sekunden',
                style: TextStyle(fontSize: 17.0),
              ),
            ),
          );
        },
        itemCount: taskData.finishedTasksLength,
      );
    });
  }
}
