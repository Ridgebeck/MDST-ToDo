import 'dart:ui';

import 'package:flutter/material.dart';
import 'screens/task_screen.dart';
import 'screens/finished_tasks_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/welcome_screen.dart';
import 'constants.dart';

class LayoutFrame extends StatefulWidget {
  @override
  _LayoutFrameState createState() => _LayoutFrameState();
}

class _LayoutFrameState extends State<LayoutFrame> {
  int _selectedIndex = 1;
  static List<Widget> _widgetOptions = [
    WelcomeScreen(),
    TaskScreen(),
    FinishedTasksScreen(),
    AnalyticsScreen(),
  ];

  void _onItemTapped(int index) {
    // move to fullscreen welcome page
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    }
    // otherwise open page as tab
    else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // TODO: remove image?
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/camouflage.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          // child: BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          //   child: Container(
          //     color: Colors.transparent,
          //   ),
          // ),
        ),
        Scaffold(
          backgroundColor:
              _selectedIndex == 3 ? kKliemannPink : kKliemannGelb, //Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
                child: const Text(
              '💩 MDST 2021 💩',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
            )),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: kKliemannGrau.withOpacity(0.8),
            unselectedItemColor: Colors.white,
            selectedItemColor: kKliemannGelb,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted_outlined),
                label: 'ToDos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_box_outlined),
                label: 'Feddich',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.stacked_bar_chart),
                label: 'Community',
              ),
            ],
          ),
          body: SafeArea(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
      ],
    );
  }
}
