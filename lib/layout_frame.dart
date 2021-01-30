import 'dart:ui';

import 'package:flutter/material.dart';
import 'screens/task_screen.dart';
import 'screens/finished_tasks_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/welcome_screen.dart';
import 'constants.dart';

import 'package:provider/provider.dart';
import 'util/task_data.dart';
import 'util/timers.dart';

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
  @override
  Widget build(BuildContext context) {
    return Consumer2<TaskData, MDSTTimer>(builder: (context, taskData, mdstTimer, child) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        taskData.updateTaskTime();
        taskData.archiveOldTasks();
        taskData.uploadData();
      });

      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.5, 0.9],
                colors: [
                  kKliemannPink,
                  kKliemannGelb,
                  kKliemannBlau,
                ],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              // _selectedIndex == 3 ? kKliemannPink : kKliemannGelb, //Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Center(
                  child: Container(
                    height: 100.0,
                    child: Column(
                      children: [
                        Expanded(flex: 4, child: Container()),
                        Expanded(
                          flex: 15,
                          child: FittedBox(
                            child: Text(
                              'MDST 2021',
                              style: TextStyle(
                                color: kKliemannGrau,
                                fontFamily: 'Monoton',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(flex: 3, child: Container()),
                      ],
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: kKliemannGrau.withOpacity(0.5),
                elevation: 0.0,
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
                    label: 'Stats',
                  ),
                ],
              ),
              body: SafeArea(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ),
          ),
        ],
      );
    });
  }
}
