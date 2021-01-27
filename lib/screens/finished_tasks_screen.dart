import 'package:MDST_todo/widgets/todo_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../util/task_data.dart';
import '../util/task.dart';
import '../constants.dart';
import '../widgets/slide_widget.dart';
import '../widgets/gif_page.dart';

class FinishedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {
      if (taskData.finishedTasksLength == 0) {
        return GifPage(
          titleTextList: [
            Text('Komm schon.', style: kGifTextStyle),
            Text("Auf los geht's los!", style: kGifTextStyle),
          ],
          assetImageString: 'assets/motivation.gif',
          subtitleTextList: [
            Text('💡 Einfach mal machen. 💡', style: kGifTextStyle),
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
                //bottom: Text(finishedTask.infoText),
              ),
            );
          },
          itemCount: taskData.finishedTasksLength,
        );
      }
    });
  }
}
