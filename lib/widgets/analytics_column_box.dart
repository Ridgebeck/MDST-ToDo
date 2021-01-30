import 'package:flutter/material.dart';
import '../constants.dart';
import '../util/task_data.dart';

class AnalyticsColumnBox extends StatelessWidget {
  AnalyticsColumnBox({this.type, this.taskData});
  final entryType type;
  final TaskData taskData;

  @override
  Widget build(BuildContext context) {
    // Map<String, List<dynamic>> top3Entries = taskData.loadTopCommunityEntries(3, type);
    // List<dynamic> topEmojis = top3Entries['topEmojis'];
    // List<dynamic> topDuration = top3Entries['topDuration'];

    List topEntries = type == entryType.category
        ? taskData.topCommunityCategories
        : taskData.topCommunityActivities;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      type == entryType.category ? 'Top 3 Kategorien' : 'Top 3 Aktivitäten',
                      style: kStatsTitleStyle,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                        child: FittedBox(
                            child: Text(
                          '${topEntries[0]['emoji']}  ${(topEntries[0]['minutes'] / 60).round()} Stunden',
                          style: TextStyle(fontSize: 18.0, color: kKliemannGrau),
                        )),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                        child: FittedBox(
                            child: Text(
                          '${topEntries[1]['emoji']}  ${(topEntries[1]['minutes'] / 60).round()} Stunden',
                          style: TextStyle(fontSize: 18.0, color: kKliemannGrau),
                        )),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                        child: FittedBox(
                            child: Text(
                          '${topEntries[2]['emoji']}  ${(topEntries[2]['minutes'] / 60).round()} Stunden',
                          style: TextStyle(fontSize: 18.0, color: kKliemannGrau),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
