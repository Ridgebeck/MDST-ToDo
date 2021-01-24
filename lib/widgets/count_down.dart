import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/timers.dart';

const kTextColor = Colors.white;

class CountDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BeforeTimer>(builder: (context, beforeTimer, child) {
      return SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 22.0, right: 22.0, top: 27.0),
          //color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    'noch',
                    style: TextStyle(color: kTextColor, fontSize: 22.0),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${beforeTimer.timeDelta['days']}',
                    style:
                        TextStyle(color: kTextColor, fontSize: 50.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    beforeTimer.timeDelta['days'] > 1 ? 'Tage' : 'Tag',
                    style: TextStyle(color: kTextColor, fontSize: 40.0),
                  ),
                  SizedBox(width: 20.0),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    '${beforeTimer.timeDelta['hours']}',
                    style:
                        TextStyle(color: kTextColor, fontSize: 45.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    beforeTimer.timeDelta['hours'] > 1 ? 'Stunden' : 'Stunde',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 35.0,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    'und',
                    style: TextStyle(color: kTextColor, fontSize: 20.0),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${beforeTimer.timeDelta['minutes']}',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    beforeTimer.timeDelta['minutes'] > 1 ? 'Minuten' : 'Minute',
                    style: TextStyle(color: kTextColor, fontSize: 27.0),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        'bis zum',
                        style: TextStyle(color: kTextColor, fontSize: 22.0),
                      ),
                      SizedBox(width: 15.0),
                      Text(
                        '#MDST21',
                        style: TextStyle(
                            color: kTextColor, fontSize: 50.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
