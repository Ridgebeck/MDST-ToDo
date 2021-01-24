import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../util/task_data.dart';

const Color kCardColor = Color(0xCCEEEEEE);
final DateTime endDate = DateTime(2021, 2, 8);
//const oneSec = const Duration(seconds: 10);

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // decoration: BoxDecoration(
              //   color: kCardColor,
              //   borderRadius: BorderRadius.circular(15.0),
              // ),
              height: 50.0,
              child: Center(
                child: Text(
                  'Deine Stats',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: kKliemannGrau,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
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
                  title: 'Gesamtzeit',
                  emoji: '💪',
                  subtitle: '5h 21 min geschuftet',
                )), //AnalyticsCard(TotalUsers())),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                    child: AnalyticsTextBox(
                  title: 'Top Kategorie',
                  emoji: '🏠',
                  subtitle: '210 min',
                )),
                Expanded(
                    child: AnalyticsTextBox(
                  title: 'Top Aktivität',
                  emoji: '🛠',
                  subtitle: '150 min',
                )),
              ],
            ),
          ),
          SizedBox(height: 30.0),
        ],
      );
    });
  }
}

//String title, String emoji, String subtitle
class AnalyticsTextBox extends StatelessWidget {
  AnalyticsTextBox({this.title, this.emoji, this.subtitle});
  final String title;
  final String emoji;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: kKliemannGrau),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),
          Text(
            emoji,
            style: TextStyle(fontSize: 50.0),
          ),
          SizedBox(height: 20.0),
          Text(
            subtitle,
            style: TextStyle(fontSize: 20.0, color: kKliemannGrau),
            textAlign: TextAlign.center,
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
      padding: const EdgeInsets.all(15.0),
      child: CircularPercentIndicator(
        percent: ratioDone,
        radius: 140,
        progressColor: kKliemannGrau,
        backgroundColor: Colors.grey[200].withOpacity(0.6),
        lineWidth: 15.0,
        center: Text(
          '✅',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: kKliemannGrau,
          ),
        ),
        footer: Text(
          '$finishedTasksLength von ${activeTasksLength + finishedTasksLength} Aufgaben erledigt',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: kKliemannGrau,
          ),
        ),
        circularStrokeCap: CircularStrokeCap.round,
      ),
    );
  }
}
