import 'package:flutter/material.dart';
import '../constants.dart';

class GifPage extends StatelessWidget {
  GifPage({
    this.titleTextList,
    this.subtitleTextList,
    this.hasFingers = false,
    @required this.assetImageString,
  });
  final List<Text> titleTextList;
  final List<Text> subtitleTextList;
  final String assetImageString;
  final bool hasFingers;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        titleTextList == null
            ? Expanded(flex: 2, child: Container())
            : Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        children: titleTextList,
                      ),
                    ),
                  ),
                ),
              ),
        Expanded(
          flex: 3,
          child: Container(
            height: 260.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(assetImageString), //'assets/notasks.gif'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        subtitleTextList == null
            ? Expanded(flex: 2, child: Container())
            : Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        children: subtitleTextList,
                      ),
                    ),
                  ),
                ),
              ),
        hasFingers
            ? Expanded(
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '👉 👉🏼 👉🏿',
                      //style: TextStyle(fontSize: 80.0),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
