import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CircularIndicator extends StatelessWidget {
  CircularIndicator({this.activeTasksLength, this.finishedTasksLength, this.ratioDone});
  final int activeTasksLength;
  final int finishedTasksLength;
  final double ratioDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          SizedBox(height: 10.0),
          Expanded(
            flex: 5,
            child: FittedBox(
              fit: BoxFit.contain,
              child: CircularPercentIndicator(
                percent: ratioDone,
                radius: 140,
                progressColor: kKliemannGrau,
                backgroundColor: Colors.grey[200].withOpacity(0.6),
                lineWidth: 15.0,
                center: Text(
                  '✅',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: kKliemannGrau,
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  children: [
                    Text(
                      '$finishedTasksLength von ${activeTasksLength + finishedTasksLength}',
                      textAlign: TextAlign.center,
                      style: kStatsSubtitleStyle,
                    ),
                    Text(
                      'Aufgaben erledigt',
                      textAlign: TextAlign.center,
                      style: kStatsSubtitleStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
