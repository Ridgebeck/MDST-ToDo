import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/timers.dart';

const kTextColor = Colors.white;

class CountDown extends StatelessWidget {
  CountDown(this.timer);
  final MDSTTimer timer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
        child: Column(
          children: [
            (timer.minutesRatio > 0)
                ? Container()
                : Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FittedBox(
                          child: Text(
                            'noch',
                            style: TextStyle(color: kTextColor, fontSize: 22.0),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        FittedBox(
                          child: Text(
                            '${timer.timeDeltaStart['days']}',
                            style: TextStyle(
                                color: kTextColor, fontSize: 55.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        FittedBox(
                          child: Text(
                            timer.timeDeltaStart['days'] > 1 ? 'Tage' : 'Tag',
                            style: TextStyle(color: kTextColor, fontSize: 40.0),
                          ),
                        ),
                        SizedBox(width: 30.0),
                      ],
                    ),
                  ),
            Expanded(child: Container()),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  SizedBox(width: 20.0),
                  (timer.minutesRatio > 0)
                      ? FittedBox(
                          child: Text(
                            'noch',
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 20.0,
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(width: 10.0),
                  FittedBox(
                    child: Text(
                      (timer.minutesRatio > 0)
                          ? '${timer.timeDeltaEnd['hours']}'
                          : '${timer.timeDeltaStart['hours']}',
                      style:
                          TextStyle(color: kTextColor, fontSize: 50.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  FittedBox(
                    child: Text(
                      (timer.minutesRatio > 0)
                          ? timer.timeDeltaEnd['hours'] > 1
                              ? 'Stunden'
                              : 'Stunde'
                          : timer.timeDeltaStart['hours'] > 1
                              ? 'Stunden'
                              : 'Stunde',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 35.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FittedBox(
                    child: Text(
                      'und',
                      style: TextStyle(color: kTextColor, fontSize: 20.0),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  FittedBox(
                    child: Text(
                      (timer.minutesRatio > 0)
                          ? '${timer.timeDeltaEnd['minutes']}'
                          : '${timer.timeDeltaStart['minutes']}',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  FittedBox(
                    child: Text(
                      (timer.minutesRatio > 0)
                          ? timer.timeDeltaEnd['minutes'] > 1
                              ? 'Minuten'
                              : 'Minute'
                          : timer.timeDeltaStart['minutes'] > 1
                              ? 'Minuten'
                              : 'Minute',
                      style: TextStyle(color: kTextColor, fontSize: 27.0),
                    ),
                  ),
                  SizedBox(width: 30.0),
                ],
              ),
            ),
            Expanded(child: Container()),
            Expanded(
              flex: 5,
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: (timer.minutesRatio > 0)
                      ? [
                          SizedBox(width: 5.0),
                          FittedBox(
                            child: Text(
                              'zum',
                              style: TextStyle(color: kTextColor, fontSize: 12.0),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Container(
                            width: 40.0,
                            child: FittedBox(
                              child: Text(
                                '💩',
                                style: TextStyle(
                                  fontSize: 200.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          FittedBox(
                            child: Text(
                              'erledigen',
                              style: TextStyle(
                                color: kTextColor,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ]
                      : [
                          FittedBox(
                            child: Text(
                              'bis zum',
                              style: TextStyle(color: kTextColor, fontSize: 25.0),
                            ),
                          ),
                          SizedBox(width: 15.0),
                          FittedBox(
                            child: Text(
                              '#MDST21',
                              style: TextStyle(
                                  color: kTextColor, fontSize: 70.0, fontWeight: FontWeight.bold),
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
