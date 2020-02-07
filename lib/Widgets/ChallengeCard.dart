import 'package:flutter/material.dart';
class ChallengeCard extends StatefulWidget{
  @override
  ChallengeCardState createState()=> ChallengeCardState();
}
class ChallengeCardState extends State<ChallengeCard>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(8.0),
      child:Card(
        child: Column(
          children: <Widget>[
            Text("Create a Challenge",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
            

          ],
        ),
      ),
    );
  }

}