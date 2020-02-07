import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget{
  BigInt reg;
  BigInt voting;
  BigInt total;
  BalanceCard({this.reg, this.voting, this.total});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(50),
          )
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Your Tokens : \n\t\t"+total.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
            SizedBox(
              height: 10,
            ),
            Text("Your Approved Tokens :", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Registry",style: TextStyle(fontWeight:  FontWeight.bold, color: Colors.blue),),
                    reg==BigInt.from(0)?Text("0"): Text((reg.toString())),
                  ],
                ),

                Column(
                  children: <Widget>[
                    Text("Voting",style: TextStyle(fontWeight:  FontWeight.bold, color: Colors.blue),),
                    voting==BigInt.from(0)?Text("0"): Text((voting.toString())),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}