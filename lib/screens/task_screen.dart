import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

import '../util/box.dart';
import '../util/task.dart';
import '../util/task_data.dart';
import '../constants.dart';

import 'add_task_screen.dart';

import '../widgets/hourly_countdown.dart';
import '../widgets/progress_bar.dart';
import '../widgets/todo_tile.dart';
import '../widgets/slide_widget.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> with SingleTickerProviderStateMixin {
  String activeActivity;
  String activeCategory;
  String activeDescription;

  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[200].withOpacity(0.9),
          child: Icon(
            Icons.add,
            size: 35.0,
            color: kKliemannGrau,
          ),
          onPressed: () async {
            //await taskData.init();
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => AddTaskScreen(),
            );
          },
        ),
        body: taskData.activeTasksLength == 0 && taskData.finishedTasksLength == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Wie, noch keine Projekte??!!',
                            style: TextStyle(color: kKliemannGrau, fontSize: 35),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 260.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/notasks.gif'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Nee neee neee. Jetzt aber mal schnell starten.',
                            style: TextStyle(color: kKliemannGrau, fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        //Image.asset('assets/notasks.gif'),
                      ],
                    ),
                  ),
                  Container(
                      height: 65.0,
                      child: Text(
                        '👉 👉🏼 👉🏿',
                        style: TextStyle(fontSize: 40.0),
                      )),
                ],
              )
            : Column(
                children: [
                  HourlyCountdown(),
                  ProgressBar(taskData: taskData),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      // Prevent the ListView from scrolling when an item is
                      // currently being dragged.
                      physics: taskData.inReorder ? const NeverScrollableScrollPhysics() : null,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      children: <Widget>[
                        _buildVerticalTaskList(taskData),
                        // TODO: delete box when not needed
                        //const SizedBox(height: 1000),
                      ],
                    ),
                  ),
                ],
              ),
      );
    });
  }

  // A vertically reorderable list.
  Widget _buildVerticalTaskList(TaskData taskData) {
    //final theme = Theme.of(context);

    Widget buildReorderable(
      Task task,
      Widget Function(Widget tile) transitionBuilder,
    ) {
      return Reorderable(
        key: ValueKey(task),
        builder: (context, dragAnimation, inDrag) {
          final t = dragAnimation.value;
          final tile = _buildTile(t, task, taskData);

          // If the item is in drag, only return the tile as the
          // SizeFadeTransition would clip the shadow.
          if (t > 0.0) {
            return tile;
          }

          return transitionBuilder(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                tile,
                //const Divider(height: 0),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    }

    return ImplicitlyAnimatedReorderableList<Task>(
      items: taskData.activeTasks, //activeTasks,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
      onReorderStarted: (item, index) =>
          taskData.setInReorder(true), //setState(() => inReorder = true),
      onReorderFinished: (movedItem, from, to, newItems) {
        // Update the underlying data when the item has been reordered!

        //onReorderFinished(newItems);
        taskData.onReorderFinished(newItems, scrollController);
      },
      itemBuilder: (context, itemAnimation, task, index) {
        //lang, index) {
        return buildReorderable(task, (tile) {
          return SizeFadeTransition(
            sizeFraction: 0.7,
            curve: Curves.easeInOut,
            animation: itemAnimation,
            child: tile,
          );
        });
      },
      updateItemBuilder: (context, itemAnimation, task) {
        return buildReorderable(task, (tile) {
          return FadeTransition(
            opacity: itemAnimation,
            child: tile,
          );
        });
      },
    );
  }

  Widget _buildTile(double t, Task task, TaskData taskData) {
    //final theme = Theme.of(context);
    //final textTheme = theme.textTheme;
    //final color = Color.lerp(Colors.white, Colors.grey.shade100, t);

    //final elevation = lerpDouble(0, 8, t);

    final List<Widget> doneActions = [
      SlideWidget(
        boxColor: Colors.green,
        text: 'Feddich',
        iconData: Icons.check,
        onTapFunction: () {
          taskData.moveToFinishedList(task);
        },
      ),
    ];

    final List<Widget> deleteActions = [
      SlideWidget(
        boxColor: Colors.redAccent,
        text: 'Wech damit',
        iconData: Icons.delete,
        onTapFunction: () {
          taskData.removeActiveTask(task);
        },
      ),
    ];

    return Slidable(
      actionPane: const SlidableBehindActionPane(),
      actions: task.isActive ? doneActions : [],
      actionExtentRatio: 0.25,
      secondaryActions: deleteActions,
      child: TodoTile(
        task: task,
        leading: PlayButton(task: task, taskData: taskData),
        trailing: HandleIcon(task: task),
        bottom: Text(
          task.infoText,
          style: task.isActive ? kInfoTextStyleActive : kInfoTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

class PlayButton extends StatelessWidget {
  PlayButton({
    @required this.taskData,
    @required this.task,
  });

  final TaskData taskData;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            taskData.toggleActivity(task);
          },
          splashColor: task.isActive ? kActiveColor : kInactiveColor,
          child: Icon(
            task.isActive ? Icons.pause : Icons.play_circle_outline,
            size: kLeadingIconSize,
            color: task.isActive ? kActiveColor : kInactiveColor,
          ),
        ),
      ),
    );
  }
}

class HandleIcon extends StatelessWidget {
  HandleIcon({
    @required this.task,
  });
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Handle(
      delay: Duration(milliseconds: 100),
      child: Icon(
        Icons.reorder_rounded,
        size: 40.0,
        color: task.isActive ? kActiveColor : kInactiveColor,
      ),
    );
  }
}
