import 'package:MDST_todo/widgets/todo_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../util/task_data.dart';
import '../util/task.dart';
import '../constants.dart';
import '../widgets/slide_widget.dart';

class FinishedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {
      if (taskData.finishedTasksLength == 0) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Das erste Projekt ist immer das schwerste',
                style: TextStyle(color: kKliemannGrau, fontSize: 35),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 260.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/motivation.gif'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Kleiner Tip: Einfach machen. 💡',
                style: TextStyle(color: kKliemannGrau, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            //Image.asset('assets/notasks.gif'),
          ],
        );
      } else {
        return ListView.separated(
          //reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          separatorBuilder: (context, index) => SizedBox(
            height: 10.0,
          ),
          itemBuilder: (context, index) {
            final List<Task> reverseList = taskData.finishedTasks.reversed.toList();
            final Task finishedTask = reverseList[index];

            final List<Widget> deleteActions = [
              SlideWidget(
                boxColor: Colors.redAccent,
                text: 'Wech damit',
                iconData: Icons.delete,
                onTapFunction: () {
                  taskData.removeFinishedTask(finishedTask);
                },
              ),
            ];

            return Slidable(
              actionPane: const SlidableBehindActionPane(),
              //actions: finishedTask.isActive ? deleteActions : [],
              actionExtentRatio: 0.25,
              secondaryActions: deleteActions,
              child: TodoTile(
                task: finishedTask,
                leading: Icon(
                  Icons.check_circle_outline,
                  size: kLeadingIconSize,
                  color: kInactiveColor,
                ),
                trailing: Text(
                  '${finishedTask.totalTime.inMinutes} min',
                  style: TextStyle(color: kInactiveColor),
                ),
                bottom: Text(''),
              ),
            );
          },
          itemCount: taskData.finishedTasksLength,
        );
      }
    });
  }
}
