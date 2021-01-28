import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:provider/provider.dart';
import '../util/task_data.dart';
import '../widgets/circular_indicator.dart';
import '../widgets/analytics_textbox.dart';
import '../widgets/analytics_column_box.dart';

const Color kCardColor = Color(0xCCEEEEEE);

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {
      return Column(
        children: [
          Expanded(child: Container()),
          Expanded(
            flex: 4,
            child: Container(
              // decoration: BoxDecoration(
              //   color: kCardColor,
              //   borderRadius: BorderRadius.circular(15.0),
              // ),
              height: 0.0,
              child: Center(
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(child: Container()),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: FittedBox(
                                  child: Text(
                                'Du',
                                style: TextStyle(
                                  fontSize: 50.0,
                                  fontWeight: taskData.communitySwitch
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              )),
                            )),
                            Expanded(child: FittedBox(child: Text('😀'))),
                            CupertinoSwitch(
                              value: taskData.communitySwitch,
                              trackColor: kKliemannBlau,
                              activeColor: kKliemannBlau,
                              onChanged: (newValue) {
                                taskData.setCommunitySwitch(newValue);
                              },
                            ),
                            Expanded(child: FittedBox(child: Text('🌍'))),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                  child: Text(
                                'Alle',
                                style: TextStyle(
                                  fontSize: 50.0,
                                  fontWeight: taskData.communitySwitch
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                textAlign: TextAlign.left,
                              )),
                            )),
                            Expanded(child: Container()),
                          ],
                        )),
                    Expanded(child: Container()),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Row(
              children: [
                Expanded(
                  child: taskData.communitySwitch
                      ? CircularIndicator(
                          activeTasksLength: 2540,
                          finishedTasksLength: 1835,
                          ratioDone: 1835 / (2540 + 1835),
                        )
                      : CircularIndicator(
                          activeTasksLength: taskData.activeTasksLength,
                          finishedTasksLength: taskData.finishedTasksLength,
                          ratioDone: taskData.ratioDone,
                        ),
                ), // AnalyticsCard(CircularIndicator())),
                Expanded(
                  child: AnalyticsTextBox(
                    title: 'Insgesamt',
                    emoji: '💪',
                    subtitleText: [
                      Text(
                        taskData.communitySwitch
                            ? '${taskData.communityTotalTimeToday['hours']} Stunden und '
                            : '${taskData.myTotalTimeToday['hours']} Stunden und ',
                        style: kStatsSubtitleStyle,
                      ),
                      Text(
                        taskData.communitySwitch
                            ? '${taskData.communityTotalTimeToday['minutes']} Minuten geschuftet'
                            : '${taskData.myTotalTimeToday['minutes']} Minuten geschuftet',
                        style: kStatsSubtitleStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 20,
            child: Row(
              children: taskData.communitySwitch
                  ? [
                      AnalyticsColumnBox(
                        type: entryType.category,
                        taskData: taskData,
                      ),
                      AnalyticsColumnBox(type: entryType.activity, taskData: taskData),
                    ]
                  : [
                      Expanded(
                        child: AnalyticsTextBox(
                          title: 'Top Kategorie',
                          emoji: taskData.topPersonalCategory.keys.first,
                          subtitleText: [
                            Text(
                              '${taskData.topPersonalCategory.values.first.inMinutes.toString()} Minuten',
                              style: kStatsSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: AnalyticsTextBox(
                        title: 'Top Aktivität',
                        emoji: taskData.topPersonalActivity.keys.first,
                        subtitleText: [
                          Text(
                            '${taskData.topPersonalActivity.values.first.inMinutes.toString()} Minuten',
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
