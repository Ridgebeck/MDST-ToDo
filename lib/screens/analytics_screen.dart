import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:percent_indicator/percent_indicator.dart';

const Color kCardColor = Color(0xCCEEEEEE);
final DateTime endDate = DateTime(2021, 2, 8);
const oneSec = const Duration(seconds: 10);

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            height: 50.0,
            child: Center(
              child: Text(
                '15h 20min - büschn Zeit is noch',
                style: TextStyle(
                  fontSize: 20.0,
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
              Expanded(child: AnalyticsCard(CircularIndicator())),
              Expanded(child: AnalyticsCard(TotalUsers())),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnalyticsCard(Top3()),
            ),
          ),
        ),
      ],
    );
  }
}

class Top3 extends StatelessWidget {
  const Top3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Das treibt die Community',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: kKliemannGrau,
          ),
        ),
        Text(
          '🔥   400 arbeiten gerade am 🚘',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: kKliemannGrau,
          ),
        ),
        Text(
          '✅   200 Aufgaben im 🏠 erledigt',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: kKliemannGrau,
          ),
        ),
        Text(
          '🤷‍♀   52 haben hingeschmissen',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: kKliemannGrau,
          ),
        ),
      ],
    );
  }
}

class TotalUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '2.560',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: kKliemannGrau,
          ),
        ),
        Text(
          'Leude am 💩 machen.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: kKliemannGrau,
          ),
        ),
      ],
    );
  }
}

// TODO: Card size should be the same
class AnalyticsCard extends StatelessWidget {
  final Widget child;
  AnalyticsCard(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey[200].withOpacity(0.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: child,
      ),
    );
  }
}

class CircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      percent: 0.7,
      // TODO: change dynamically
      radius: 140,
      progressColor: kKliemannGrau,
      backgroundColor: Colors.grey[200].withOpacity(0.6),
      lineWidth: 15.0,
      center: Text(
        '70%',
        style: TextStyle(
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
          color: kKliemannGrau,
        ),
      ),
      footer: Text(
        '4.058 von 8.650 Aufgaben erledigt',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: kKliemannGrau,
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
