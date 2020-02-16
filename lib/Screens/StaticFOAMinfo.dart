import 'package:flutter/material.dart';

class FoamInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Text("What is FOAM?",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("FOAM provides the tools to enable a crowdsourced map and decentralized location services.",style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Open to Cartographers everywhere",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Anyone can add places to the FOAM Map and share their knowledge of t1he world.\nBecause maps get better when they’re shaped by cartographers like you.\nCollect locations – called points of interest or POIs – and contribute to an open source registry.",style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                    ),
                    Text("Community verification forcrowdsourced places.",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("A new place must go through multiple stages before it is verified.\nCartographers challenge when they find something that seems false or incorrect, starting a process in which the community votes to decide if a location should be included or removed.",style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}