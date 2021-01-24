import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../util/task_data.dart';

class ProgressBar extends StatelessWidget {
  ProgressBar({this.taskData});
  final TaskData taskData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FractionallySizedBox(
            widthFactor: 0.9,
            child: LinearPercentIndicator(
              //alignment: MainAxisAlignment.center,
              lineHeight: 25.0,
              backgroundColor: kKliemannGrau, //Colors.grey[200],
              progressColor: kKliemannBlau, //Colors.greenAccent,
              percent: taskData.ratioDone ?? 0,
              center: Text(
                taskData.percentageDone == 0
                    ? "Hier gibt's keinen Kakao"
                    : taskData.percentageDone.toStringAsFixed(1) + ' % erledigt',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
