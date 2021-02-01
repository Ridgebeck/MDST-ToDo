import '../constants.dart';
import '../util/share.dart';
import '../util/timers.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../layout_frame.dart';
import '../widgets/count_down.dart';
import '../widgets/top_widget_after_mdst.dart';
import 'package:flutter_circular_text/circular_text.dart';

const kTextColor = Colors.white;
//final DateTime theDate = DateTime(2021, 2, 7);

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  VideoPlayerController _controller;

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
    //_timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MDSTTimer>(builder: (context, timer, child) {
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
            bottom: 210.0,
            width: 270.0,
            height: 160.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage('assets/mdst2020.jpg'), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -5.0,
            left: -160.0,
            right: 0.0,
            //width: 500.0,
            height: 300.0,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fynn_shows.png'),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 30.0,
            width: 90.0,
            height: 90.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: GestureDetector(
                onTap: () {
                  share();
                },
                child: Stack(children: [
                  CircularText(
                    children: [
                      TextItem(
                        text: Text(
                          'Geteiltes Leid'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                          ),
                        ),
                        space: 20,
                        startAngle: -90,
                        startAngleAlignment: StartAngleAlignment.center,
                        direction: CircularTextDirection.clockwise,
                      ),
                    ],
                    radius: 150,
                    position: CircularTextPosition.inside,
                    backgroundPaint: Paint()..color = kKliemannGrau,
                  ),
                  Center(
                    child: Icon(
                      Icons.share_rounded,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ),
                ]),
              ),
            ),
            //Container(
            //   color: Colors.green,
            // ),
          ),
          Positioned(
            right: -55.0,
            bottom: 210.0,
            width: 270.0,
            height: 160.0,
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
            bottom: 390.0,
            left: 0.0,
            right: 0.0,
            //width: 500.0,
            //height: 250.0,
            child: TopWidget(timer), //_showTopWidget(),
          ),
          Positioned(
            right: 30,
            bottom: 30,
            height: 110,
            width: 110,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  timer.minutesRatio >= 1
                      ? Navigator.push(
                          (context), MaterialPageRoute(builder: (context) => LayoutFrame(3)))
                      : Navigator.push(
                          (context), MaterialPageRoute(builder: (context) => LayoutFrame(1)));
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
                      child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: FittedBox(
                      child: Column(
                        children: timer.minutesRatio >= 1
                            ? [
                                Text(
                                  "Deine",
                                  style: TextStyle(color: Colors.white, fontSize: 50.0),
                                ),
                                Text(
                                  "Stats ",
                                  style: TextStyle(color: Colors.white, fontSize: 50.0),
                                ),
                                Text(
                                  "➡",
                                  style: TextStyle(color: Colors.white, fontSize: 50.0),
                                ),
                              ]
                            : [
                                Text(
                                  "Hier",
                                  style: TextStyle(color: Colors.white, fontSize: 50.0),
                                ),
                                Text(
                                  "geht's",
                                  style: TextStyle(color: Colors.white, fontSize: 50.0),
                                ),
                                Text(
                                  "los ➡",
                                  style: TextStyle(color: Colors.white, fontSize: 50.0),
                                ),
                              ],
                      ),
                    ),
                  )),
                ),
              ),
            ),
          )
        ]),
      );
    });
  }
}

class TopWidget extends StatelessWidget {
  TopWidget(this.timer);
  final MDSTTimer timer;

  @override
  Widget build(BuildContext context) {
    if (timer.minutesRatio >= 1) {
      return TopWidgetAfterMDST();
      // display countdown before and during MDST
    } else {
      return CountDown(timer);
    }
  }
}
