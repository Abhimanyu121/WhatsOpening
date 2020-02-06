import 'package:flutter/material.dart';
import 'package:flu/Models/POIModel.dart';
class PanelUi extends StatefulWidget{
  POIModel model;
  PanelUi(POIModel model){
    this.model = model;
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
    print("building stuff");
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Does this place exist on site?",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Row(
              mainAxisAlignment:  MainAxisAlignment.center,
              children: <Widget>[

                RaisedButton(
                  color: Colors.green,
                  onPressed: (){},
                  child: Icon(Icons.check),
                ),
                SizedBox(
                  width: 35,
                ),
                RaisedButton(
                  color: Colors.redAccent,
                  onPressed: (){},
                  child: Icon(Icons.cancel),
                )
              ],
            ),
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