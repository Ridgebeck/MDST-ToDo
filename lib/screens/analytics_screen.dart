import 'package:MDST_todo/util/timers.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../util/task_data.dart';

const Color kCardColor = Color(0xCCEEEEEE);

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {
      return Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // decoration: BoxDecoration(
                //   color: kCardColor,
                //   borderRadius: BorderRadius.circular(15.0),
                // ),
                height: 50.0,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      'Was du geschafft hast',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: kKliemannGrau,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                    child: CircularIndicator(
                  activeTasksLength: taskData.activeTasksLength,
                  finishedTasksLength: taskData.finishedTasksLength,
                  ratioDone: taskData.ratioDone,
                )), // AnalyticsCard(CircularIndicator())),
                Expanded(
                  child: AnalyticsTextBox(
                    title: 'Insgesamt',
                    emoji: '💪',
                    subtitleText: [
                      Text(
                        '${taskData.totalTime['hours']} Stunden und ',
                        style: kStatsSubtitleStyle,
                      ),
                      Text(
                        '${taskData.totalTime['minutes']} Minuten geschuftet',
                        style: kStatsSubtitleStyle,
                      ),
                    ],
                    // Text(
                    //   subtitle,
                    //   style: TextStyle(fontSize: 15.0, color: kKliemannGrau),
                    //   //textAlign: TextAlign.center,
                    // ),

                    // subtitle: '${taskData.totalTime['hours']} Stunden und '
                    //     '${taskData.totalTime['minutes']} Minuten geschuftet',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: AnalyticsTextBox(
                    title: 'Top Kategorie',
                    emoji: taskData.topCategory.keys.first,
                    subtitleText: [
                      Text(
                        '${taskData.topCategory.values.first.inMinutes.toString()} Minuten',
                        style: kStatsSubtitleStyle,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: AnalyticsTextBox(
                  title: 'Top Aktivität',
                  emoji: taskData.topActivity.keys.first,
                  subtitleText: [
                    Text(
                      '${taskData.topActivity.values.first.inMinutes.toString()} Minuten',
                      style: kStatsSubtitleStyle,
                    ),
                  ],
                )),
              ],
            ),
          ),
          //SizedBox(height: 30.0),
        ],
      );
    });
  }
}

//String title, String emoji, String subtitle
class AnalyticsTextBox extends StatelessWidget {
  AnalyticsTextBox({this.title, this.emoji, this.subtitleText});
  final String title;
  final String emoji;
  final List<Text> subtitleText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    title,
                    style: kStatsTitleStyle,
                    //textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          //SizedBox(height: 20.0),
          Expanded(
            child: Column(
              children: [
                Expanded(child: Container()),
                Expanded(
                  flex: 5,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      emoji,
                      style: TextStyle(fontSize: 50.0),
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          //SizedBox(height: 20.0),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  children: subtitleText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
