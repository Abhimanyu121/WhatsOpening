import 'package:flutter/material.dart';
import 'package:flu/home.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Constants.dart';
import 'Screens/Dashboard.dart';
import 'Screens/Allowance.dart';
import 'Screens/ChallengeScreen.dart';
import 'Screens/LoginWithSkip.dart';
import 'Screens/LoginWithoutSkip.dart';
import 'Screens/NewPoi.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentWidget = LoginWithSkip();
  Future<dynamic> _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("loggedIn");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLogin().then((value) {
      if (value == null || value == false) {
        print(value.toString());
        setState(() {
          currentWidget = LoginWithSkip();
        });
      } else {
        print(value.toString());
        setState(() {
          currentWidget = Home();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: notWhite, // navigation bar color
        statusBarColor: notWhite,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarDividerColor: background,
        systemNavigationBarIconBrightness: Brightness.dark // status bar color
        ));
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        //primarySwatch: Colors.white,
      ),

      debugShowCheckedModeBanner: false,
      //theme: ThemeData(primarySwatch: Colors.white),

      routes: {
        '/dashboard': (context) => Dashboard(),
        '/allowance': (context) => AllowancePage(),
        '/ChallengeScreen': (context) => ChallengeScreen(),
        '/LoginWithSkip': (context) => LoginWithSkip(),
        '/LoginWithoutSkip': (context) => LoginWithoutSkip(),
        '/home': (context) => Home(),
        '/AddPoi': (context) => NewPoi(),
      },
      title: 'FOAM MAP',

      home: currentWidget,
    );
  }
}
