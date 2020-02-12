import 'package:flu/Models/ArgListPanelChallege.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flu/Models/POIModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Map.dart';
class PanelUi extends StatefulWidget{

  POIModel model;
  Function refresh;
  GlobalKey<MapState> _MapState;
  PanelUi(POIModel model, Key key, Function refresh){
    this.model = model;
    this._MapState = key;
    this.refresh = refresh;
  }
  @override
  PanelState createState() =>PanelState() ;
}
class PanelState extends State<PanelUi>{
  BuildContext context;
  var colorArr = [Colors.blue,Colors.redAccent,Colors.green, Colors.deepOrange];
  bool state =false;


  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    print("check state");
    print(widget.model.state);
    return Container(
      child: Column(

        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),

          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
            child: Text(
              widget.model.name,
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
            ),
          ),

          Center(
            child: SizedBox(
              height: 70,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount   : widget.model.tags.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: ((BuildContext context, int index){
                  return SizedBox(
                    height: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 10,
                        child: Card(

                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          color: colorArr[index%4],
                          child: SizedBox(
                              width:100,
                              child: Center(child: Text(widget.model.tags[index],textAlign: TextAlign.center,))),
                        ),
                      ),
                    ),
                  );
                }) ,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
            child: Text(
              "Owner:",
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
            child: Text(
              "${widget.model.owner}",
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
            child: Text(
              "Status:",
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
            child: Text(
              "${widget.model.state}",
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: widget.model.state=="applied"?CupertinoButton.filled(child: Text("Challenge the Place"), onPressed: ()async {
              ArgListPanelChallenge args= new ArgListPanelChallenge();
              args.model= widget.model;
              args.key = widget._MapState;
              widget.refresh();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var pvt = prefs.getString("privateKey");
              if(pvt!=null){
                Navigator.pushNamed(
                  context,
                  '/ChallengeScreen',
                  arguments: args,
                );
              }
              else{
                Navigator.pushNamed(context, '/LoginWithouSkip');
              }



            }):Container(),
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
//
}