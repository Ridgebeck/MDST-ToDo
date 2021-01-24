import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/error_screen.dart';
import 'package:flutter/services.dart';
import 'util/task_data.dart';
import 'util/timers.dart';
import 'util/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    // TODO: check if screen rotation lock works on iOS
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //   ),
    // );

    return FutureBuilder(
      // Initialize FlutterFire
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorScreen();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => TaskData()),
              ChangeNotifierProvider(create: (_) => BeforeTimer()),
              ChangeNotifierProvider(create: (_) => MDSTTimer()),
              // ProxyProvider<MDSTTimer, TaskData>(
              //     update: (context, MDSTTimer mdstTimer, TaskData taskData) {
              //   print('Proxy Provider in action!');
              //   return TaskData();
              // }),
            ],
            //child:
            child: MaterialApp(
              title: 'MDST_todo',
              theme: ThemeData(canvasColor: Colors.transparent),
              debugShowCheckedModeBanner: false,
              home: WelcomeScreen(),
            ),
            //),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingScreen();
      },
    );
  }
}
