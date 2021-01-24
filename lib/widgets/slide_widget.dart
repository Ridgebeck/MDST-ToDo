import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlideWidget extends StatelessWidget {
  SlideWidget({this.boxColor, this.onTapFunction, this.text, this.iconData});
  final Color boxColor;
  final Function onTapFunction;
  final String text;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      closeOnTap: true,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      onTap: //() {
          onTapFunction,
      //taskData.removeTask(task);
      //},
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
