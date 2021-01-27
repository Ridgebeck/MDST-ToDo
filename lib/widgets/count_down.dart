import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/timers.dart';

const kTextColor = Colors.white;

class CountDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MDSTTimer>(builder: (context, timer, child) {
      return SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
          child: Column(
            children: [
              Expanded(
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
                    SizedBox(width: 30.0),
                    FittedBox(
                      child: Text(
                        '${timer.timeDeltaStart['hours']}',
                        style: TextStyle(
                            color: kTextColor, fontSize: 50.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    FittedBox(
                      child: Text(
                        timer.timeDeltaStart['hours'] > 1 ? 'Stunden' : 'Stunde',
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
                        '${timer.timeDeltaStart['minutes']}',
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
                        timer.timeDeltaStart['minutes'] > 1 ? 'Minuten' : 'Minute',
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
                    children: [
                      FittedBox(
                        child: Text(
                          'bis zum',
                          style: TextStyle(color: kTextColor, fontSize: 20.0),
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
    });
  }
}
