import 'package:flutter/material.dart';

class FoamInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Text("Welcome to FOAM Maps", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        SizedBox(
          height: 10,
        ),
        Text("Some basic FAQs",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        Text("Some basic FAQs",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        Text("Some basic FAQs",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }


}