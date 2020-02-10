import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flu/Widgets/AllowanceRegistry.dart';
import 'package:flu/Widgets/VoteAllowance.dart';
class AllowancePage extends StatefulWidget{
  @override
  AllowanceState createState() => AllowanceState();
}
class AllowanceState extends State<AllowancePage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          trailing: Icon(Icons.gps_fixed, size: 20,),
          middle: Text(
            "Change Allowance",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
      ),
      child:Container(
        //color:  Color(0xFFEDF0F2),
        color: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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