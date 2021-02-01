import 'package:flutter/material.dart';

class TopWidgetAfterMDST extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: Container()),
              Expanded(
                flex: 4,
                child: FittedBox(
                  child: Text(
                    "Geil war's!",
                    style: TextStyle(color: Colors.white, fontSize: 100.0),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Expanded(
                flex: 4,
                child: FittedBox(
                  child: Text(
                    "🙌",
                    style: TextStyle(color: Colors.white, fontSize: 200.0),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: FittedBox(
                    child: Text(
                      "Bis zum #MDST22",
                      style: TextStyle(color: Colors.white, fontSize: 100.0),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
