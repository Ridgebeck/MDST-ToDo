import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:provider/provider.dart';
import '../util/task_data.dart';
import '../widgets/circular_indicator.dart';
import '../widgets/analytics_textbox.dart';
import '../widgets/analytics_column_box.dart';
import '../widgets/gif_page.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

const Color kCardColor = Color(0xCCEEEEEE);

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {
      return DateTime.now().isBefore(DateTime.parse(mdstStart))
          ? GifPage(
              assetImageString: 'assets/no_data.gif',
              titleTextList: [Text('Noch keine Daten', style: kGifTextStyle)],
              subtitleTextList: [Text('nur nen Loch in der Hose', style: kGifTextStyle)],
            )
          : Column(
              children: [
                Expanded(child: Container()),
                Expanded(
                  flex: 4,
                  child: Container(
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

                taskData.communityDataReceived == false && taskData.communitySwitch == true
                    ? Expanded(
                        flex: 40,
                        child: GifPage(
                          titleTextList: [
                            Text(
                              'Keine Verbindung...',
                              style: TextStyle(fontSize: 50.0),
                            )
                          ],
                          assetImageString: 'assets/no_connection.gif',
                          subtitleTextList: [
                            Text(
                              'WLAN Kabel kaputt? 💔',
                              style: TextStyle(fontSize: 50.0),
                            )
                          ],
                        ),

                        // child: Container(
                        //   color: Colors.green,
                        //   child: Text('INSERT GIF HERE'),
                        // ),
                      )
                    : Expanded(
                        flex: 40,
                        child: Column(children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: taskData.communitySwitch
                                      ? CircularIndicator(
                                          activeTasksLength: taskData.communityActiveTasksToday,
                                          finishedTasksLength: taskData.communityFinishedTasksToday,
                                          ratioDone: taskData.communityRatioDone,
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
                                            ? '${taskData.communityTotalHours} Stunden und '
                                            : '${taskData.myTotalTimeToday['hours']} Stunden und ',
                                        style: kStatsSubtitleStyle,
                                      ),
                                      Text(
                                        taskData.communitySwitch
                                            ? '${taskData.communityTotalMinutes} Minuten geschuftet'
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
                            child: Row(
                              children: taskData.communitySwitch
                                  ? [
                                      taskData.topCommunityCategories.isEmpty
                                          ? Expanded(
                                              child: AnalyticsTextBox(
                                                title: 'Top 3 Kategorien',
                                                emoji: '🤷‍♀️',
                                                subtitleText: [
                                                  Text(
                                                    'Keine Community Daten :(',
                                                    style: kStatsSubtitleStyle,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Expanded(
                                              child: AnalyticsColumnBox(
                                                type: entryType.category,
                                                taskData: taskData,
                                              ),
                                            ),
                                      taskData.topCommunityActivities.isEmpty
                                          ? Expanded(
                                              child: AnalyticsTextBox(
                                                title: 'Top 3 Aktivitäten',
                                                emoji: '🤷‍♂️',
                                                subtitleText: [
                                                  Text(
                                                    'Keine Community Daten :(',
                                                    style: kStatsSubtitleStyle,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Expanded(
                                              child: AnalyticsColumnBox(
                                                type: entryType.activity,
                                                taskData: taskData,
                                              ),
                                            ),
                                    ]
                                  : [
                                      Expanded(
                                        child: AnalyticsTextBox(
                                          title: 'Top Kategorie',
                                          emoji: taskData
                                              .topEmojiAndTime(entryType.category)
                                              .keys
                                              .first,
                                          subtitleText: [
                                            Text(
                                              '${taskData.topEmojiAndTime(entryType.category).values.first.inMinutes.toString()} Minuten',
                                              style: kStatsSubtitleStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: AnalyticsTextBox(
                                        title: 'Top Aktivität',
                                        emoji:
                                            taskData.topEmojiAndTime(entryType.activity).keys.first,
                                        subtitleText: [
                                          Text(
                                            '${taskData.topEmojiAndTime(entryType.activity).values.first.inMinutes.toString()} Minuten',
                                            style: kStatsSubtitleStyle,
                                          ),
                                        ],
                                      )),
                                    ],
                            ),
                          ),
                        ]),
                      ),
                //SizedBox(height: 30.0),
              ],
            );
    });
  }
}
