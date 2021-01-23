import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import '../util/task_data.dart';

import 'add_task_screen.dart';
import '../util/box.dart';
import '../util/task.dart';
import '../constants.dart';

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
    super.initState();
    scrollController = ScrollController();
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
        body: Column(
          children: [
            Container(
              height: 30.0,
              width: double.infinity,
              color: Colors.transparent, //kKliemannBlau.withOpacity(0.8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: LinearPercentIndicator(
                      //alignment: MainAxisAlignment.center,
                      lineHeight: 20.0,
                      backgroundColor: Colors.grey[200],
                      progressColor: Colors.greenAccent,
                      percent: taskData.ratioDone ?? 0,
                      center: Text(
                        taskData.percentageDone == null
                            ? "Hier gibt's keinen Kakao"
                            : taskData.percentageDone.toStringAsFixed(1) + ' % erledigt',
                        style: TextStyle(color: kKliemannGrau),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  const SizedBox(height: 1000),
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    //final color = Color.lerp(Colors.white, Colors.grey.shade100, t);
    final elevation = lerpDouble(0, 8, t);

    final List<Widget> doneActions = taskData.activeTasksLength > 0
        ? [
      SlideAction(
        closeOnTap: true,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        onTap: () {
          // deactivate task and move to finished list
          taskData.moveToFinishedList(task);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.check,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Text(
                'Feddich!',
                style: textTheme.bodyText2.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ]
        : [];

    final List<Widget> deleteActions = taskData.activeTasksLength > 0
        ? [
      SlideAction(
        closeOnTap: true,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        onTap: () {
          taskData.removeTask(task);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Text(
                'Wech damit',
                style: textTheme.bodyText2.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ]
        : [];

    return Slidable(
      actionPane: const SlidableBehindActionPane(),
      actions: task.isActive ? doneActions : [],
      actionExtentRatio: 0.25,
      secondaryActions: deleteActions,
      child: Box(
        color:
        task.isActive ? Colors.greenAccent.withOpacity(0.9) : Colors.grey[200].withOpacity(0.9),
        elevation: elevation,
        alignment: Alignment.center,
        borderRadius: 15.0,
        // TODO: Convert to own Widget of rows
        // instead of ListTile
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          title: Text(
            task.category + ' + ' + task.activity,
            style: kTitleStyle,
            textAlign: TextAlign.center,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: kSubtitlePadding),
            child: Text(
              task.subtitle,
              style: kSubtitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50.0,
                height: 50.0,
                child:
                // Text(
                //   '${selectedTasks.indexOf(task) + 1}',
                //   style: textTheme.bodyText2.copyWith(
                //     color: kKliemannGrau,
                //     fontSize: 22,
                //   ),
                // ),

                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: task.isActive ? Icon(Icons.pause) : Icon(Icons.play_circle_outline),
                    color: kKliemannGrau,
                    iconSize: 38.0,
                    splashColor: kKliemannPink,
                    splashRadius: 35.0 / 2,
                    onPressed: () {
                      taskData.toggleActivity(task);
                    },
                  ),
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Handle(
                delay: Duration(milliseconds: 100),
                child: Icon(
                  Icons.reorder_rounded,
                  color: kKliemannGrau,
                  size: 25.0,
                ),
              ),
            ],
          ),
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
