import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/task_data.dart';
import '../util/timers.dart';

class HourlyCountdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MDSTTimer>(builder: (context, mdstTimer, child) {
      return Container(
        height: 35.0,
        width: double.infinity,
        color: Colors.transparent,
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Center(
              child: returnTextWidget(
            mdstTimer.minutesRatio,
            mdstTimer.timeDelta,
          )),
        ),
      );
    });
  }
}

Text returnTextWidget(double minutesRatio, Map<String, int> timeDelta) {
  // TODO: define three possible display options
  if (minutesRatio == 0.0) {
    return Text('Text before');
  } else if (minutesRatio == 1.0) {
    return Text('Text after');
  } else if (minutesRatio == null) {
    return Text('Text null');
  } else {
    return Text('noch ' +
        timeDelta['hours'].toString() +
        ' Stunden und ' +
        timeDelta['minutes'].toString() +
        ' Minuten');
  }
}
