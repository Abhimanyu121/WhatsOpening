import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flu/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Future<dynamic>_checkLogin()async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
       return prefs.getBool("loggedIn");


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLogin().then((value){
      if (value == null|| value ==false) {
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
    return CupertinoApp(
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      routes: {
        '/dashboard': (context) => Dashboard(),
        '/allowance': (context) => AllowancePage(),
        '/ChallengeScreen': (context) => ChallengeScreen(),
        '/LoginWithSkip': (context) => LoginWithSkip(),
        '/LoginWithoutSkip': (context) => LoginWithoutSkip(),
        '/home' : (context ) => Home(),
        '/AddPoi': (context) => NewPoi(),
      },
      title: 'FOAM MAP',
      theme: CupertinoThemeData(
        brightness:  Brightness.dark,
      ),
      home: currentWidget,
    );
  }
}

