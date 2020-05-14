import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flu/Widgets/AllowanceRegistry.dart';
import 'package:flu/Widgets/VoteAllowance.dart';

class AllowancePage extends StatefulWidget {
  @override
  AllowanceState createState() => AllowanceState();
}

class AllowanceState extends State<AllowancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Padding(
          padding: EdgeInsets.only(left: 110),
          child: Row(
            children: <Widget>[
              Text(
                "Change",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(children: <Widget>[
                Text(
                  "  ",
                ),
              ]),
              Row(
                children: <Widget>[
                  Text(
                    "Allowance",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 26.0,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                RegistryAllow(),
                SizedBox(
                  height: 10,
                ),
                VoteAllowance(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
