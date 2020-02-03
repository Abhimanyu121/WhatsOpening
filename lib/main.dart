import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flu/home.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'FOAM MAP',
      theme: CupertinoThemeData(
        brightness:  Brightness.dark,
      ),
      home: Home(),
    );
  }
}

