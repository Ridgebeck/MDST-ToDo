import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../layout_frame.dart';
//import '../util/auth.dart';

const kTextColor = Colors.white;
final DateTime theDate = DateTime(2021, 2, 7);

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  VideoPlayerController _controller;
  Timer _timer;
  Map<String, int> _timeDelta;

  Map<String, int> getTimeDelta() {
    DateTime startDate = DateTime.now();
    Duration duration = theDate.difference(startDate);
    int days = duration.inDays;
    int hours = duration.inHours - days * 24;
    int minutes = duration.inMinutes - hours * 60 - days * 24 * 60 + 1;
    return {'days': days, 'hours': hours, 'minutes': minutes};
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 10);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (DateTime.now().isAfter(theDate)) {
        timer.cancel();
        print(DateTime.now());
      } else {
        setState(() {
          _timeDelta = getTimeDelta();
        });
      }
    });
  }

  _launchURL() async {
    const url = 'https://www.youtube.com/watch?v=ksrri3TEA3A';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _timeDelta = getTimeDelta();
    startTimer();
    _controller = VideoPlayerController.asset('assets/beauties.mp4')
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size?.width ?? 0,
              height: _controller.value.size?.height ?? 0,
              child: _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
          ),
        ),
        Positioned(
          right: -55.0,
          bottom: 250.0,
          width: 290.0,
          height: 180.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/mdst2020.jpg'), fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -5.0,
          left: -160.0,
          right: 0.0,
          //width: 500.0,
          height: 350.0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fynn_shows.png'),
              ),
            ),
          ),
        ),
        Positioned(
          right: -55.0,
          bottom: 250.0,
          width: 290.0,
          height: 180.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.white,
                onTap: () {
                  _launchURL();
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          bottom: 450.0,
          left: 0.0,
          right: 0.0,
          //width: 500.0,
          //height: 250.0,
          child: SafeArea(
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
                        '${_timeDelta['days']}',
                        style: TextStyle(
                            color: kTextColor, fontSize: 50.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        _timeDelta['days'] > 1 ? 'Tage' : 'Tag',
                        style: TextStyle(color: kTextColor, fontSize: 40.0),
                      ),
                      SizedBox(width: 20.0),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        '${_timeDelta['hours']}',
                        style: TextStyle(
                            color: kTextColor, fontSize: 45.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        _timeDelta['hours'] > 1 ? 'Stunden' : 'Stunde',
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
                        '${_timeDelta['minutes']}',
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        _timeDelta['minutes'] > 1 ? 'Minuten' : 'Minute',
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
          ),
        ),
        Positioned(
          right: 40,
          bottom: 40,
          height: 130,
          width: 130,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                Navigator.push((context), MaterialPageRoute(builder: (context) => LayoutFrame()));
              },
              child: Container(
                //color: Colors.red,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    )),
                child: Center(
                    child: Text(
                  "Hier geht's los ➡",
                  style:
                      TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
