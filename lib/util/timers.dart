import 'dart:async';
import 'package:MDST_todo/util/task_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const kTimerTickRate = 10;

class MDSTTimer extends ChangeNotifier {
  MDSTTimer() {
    // start timer when class gets initialized
    // by provider at app startup
    timerCallback(_timer);
    _startTimer(kTimerTickRate);
  }
  final DateTime startDate = DateTime(2021, 1, 25);
  final DateTime endDate = DateTime(2021, 1, 26, 21, 0);

  Timer _timer;
  Map<String, int> _timeDeltaStart;
  Map<String, int> _timeDeltaEnd;
  double _minutesRatio;

  void _startTimer(int interval) {
    _timer = Timer.periodic(
      Duration(seconds: interval),
      (Timer timer) {
        timerCallback(timer);
      },
    );
  }

  timerCallback(Timer timer) {
    if (DateTime.now().isAfter(endDate)) {
      // TODO: what is displayed at end?
      _minutesRatio = 1.0;
      //timer.cancel();
    } else if (DateTime.now().isBefore(startDate)) {
      // TODO: what is displayed before MDST starts?
      _timeDeltaStart = getTimeDelta(startDate);
      _minutesRatio = 0.0;
    } else {
      // TODO: Countdown Timer (Welcome Page) during MDST?
      _timeDeltaStart = {'days': 0, 'hours': 0, 'minutes': 0};
      _timeDeltaEnd = getTimeDelta(endDate);
      _minutesRatio = 1 - (endDate.difference(DateTime.now()).inMinutes / (24 * 60));
    }
    // update UI
    notifyListeners();
  }

  Map<String, int> get timeDeltaStart {
    return _timeDeltaStart;
  }

  Map<String, int> get timeDeltaEnd {
    return _timeDeltaEnd;
  }

  double get minutesRatio {
    return _minutesRatio;
  }

  // TODO: dispose timer when app is closed???
  void cancelTimer(Timer timer) {
    _timer.cancel();
  }
}

Map<String, int> getTimeDelta(DateTime endDate) {
  DateTime startDate = DateTime.now();
  Duration duration = endDate.difference(startDate);
  int days = duration.inDays;
  int hours = duration.inHours - days * 24;
  int minutes = duration.inMinutes - hours * 60 - days * 24 * 60 + 1;
  return {'days': days, 'hours': hours, 'minutes': minutes};
}
