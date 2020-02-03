import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flu/Screens/Map.dart';
import 'package:flu/ThemeData.dart';
class Home extends StatefulWidget{
  HomeState createState() => HomeState();
}
class HomeState extends State<Home>{

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return SlidingUpPanel(
     // color: AppTheme.background,
      panel: Card(
        color: AppTheme.background,
      ),
      collapsed: Card(
        color: AppTheme.background,
      ),
      body: CupertinoPageScaffold(

        navigationBar: CupertinoNavigationBar(
          trailing: Icon(Icons.gps_fixed, size: 20,),
          middle: Text(
            "FOAM Maps",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ),

        child: MapUi(),
      ),
    );
  }


}