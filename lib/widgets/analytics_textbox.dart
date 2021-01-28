import 'package:flutter/material.dart';
import '../constants.dart';

class AnalyticsTextBox extends StatelessWidget {
  AnalyticsTextBox({this.title, this.emoji, this.subtitleText});
  final String title;
  final String emoji;
  final List<Text> subtitleText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    title,
                    style: kStatsTitleStyle,
                    //textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          //SizedBox(height: 20.0),
          Expanded(
            child: Column(
              children: [
                Expanded(child: Container()),
                Expanded(
                  flex: 5,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      emoji,
                      style: TextStyle(fontSize: 50.0),
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          //SizedBox(height: 20.0),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  children: subtitleText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
