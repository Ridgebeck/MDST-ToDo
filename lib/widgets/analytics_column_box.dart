import 'package:flutter/material.dart';
import '../constants.dart';
import '../util/task_data.dart';

class AnalyticsColumnBox extends StatelessWidget {
  AnalyticsColumnBox({this.type, this.taskData});
  final entryType type;
  final TaskData taskData;

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> top3Entries = taskData.loadTopCommunityEntries(3, type);
    List<dynamic> topEmojis = top3Entries['topEmojis'];
    List<dynamic> topDuration = top3Entries['topDuration'];

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
                          '${topEmojis[0]}  ${topDuration[0].inHours} Stunden',
                          style: TextStyle(fontSize: 18.0, color: kKliemannGrau),
                        )),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                        child: FittedBox(
                            child: Text(
                          '${topEmojis[1]}  ${topDuration[1].inHours} Stunden',
                          style: TextStyle(fontSize: 18.0, color: kKliemannGrau),
                        )),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                        child: FittedBox(
                            child: Text(
                          '${topEmojis[2]}  ${topDuration[2].inHours} Stunden',
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
