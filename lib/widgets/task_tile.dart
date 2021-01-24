import 'package:flutter/material.dart';
import '../constants.dart';
import '../util/task_data.dart';
import '../util/task.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart'
    show Handle;

class TodoTile extends StatelessWidget {
  TodoTile({this.taskData, this.task});

  final TaskData taskData;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  taskData.toggleActivity(task);
                },
                splashColor: task.isActive ? kActiveColor : kInactiveColor,
                child: Icon(
                  task.isActive ? Icons.pause : Icons.play_circle_outline,
                  size: 50.0,
                  color: task.isActive ? kActiveColor : kInactiveColor,
                ),
              ),
            ),
          ),
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
                  Text(
                    task.infoText,
                    style: task.isActive ? kInfoTextStyleActive : kInfoTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Handle(
            delay: Duration(milliseconds: 100),
            child: Icon(
              Icons.reorder_rounded,
              size: 40.0,
              color: task.isActive ? kActiveColor : kInactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}

//       ListTile(
//       contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//       title: Text(
//         task.category + '  +  ' + task.activity,
//         style: task.isActive ? kTitleStyleActive : kTitleStyle,
//         textAlign: TextAlign.center,
//       ),
//       subtitle: Padding(
//         padding: const EdgeInsets.only(top: kSubtitlePadding),
//         child: Text(
//           task.subtitle,
//           style: task.isActive ? kSubtitleStyleActive : kSubtitleStyle,
//           textAlign: TextAlign.center,
//         ),
//       ),
//       leading: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 50.0,
//             height: 50.0,
//             child: Material(
//               color: Colors.transparent,
//               child: IconButton(
//                 padding: EdgeInsets.all(0.0),
//                 icon: task.isActive ? Icon(Icons.pause) : Icon(Icons.play_circle_outline),
//                 color: task.isActive ? Colors.white : kKliemannPink,
//                 iconSize: 38.0,
//                 splashColor: kKliemannPink,
//                 splashRadius: 35.0 / 2,
//                 onPressed: () {
//                   taskData.toggleActivity(task);
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       trailing: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Handle(
//             delay: Duration(milliseconds: 100),
//             child: Icon(
//               Icons.reorder_rounded,
//               color: task.isActive ? Colors.white : kKliemannPink,
//               size: 25.0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
