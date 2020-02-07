import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flu/Screens/Map.dart';
import 'package:flu/Models/POIModel.dart';
import 'package:flu/Screens/Panel.dart';
class Home extends StatefulWidget{
  HomeState createState() => HomeState();
}
class HomeState extends State<Home>{
  POIModel model;
  bool mode = true;

  setModel(POIModel model){
    print("at callbaxk");
    setState(() {
      this.model = model;
    });
  }
  @override
  Widget build(BuildContext context) {

    return SlidingUpPanel(
      backdropTapClosesPanel: true,
      backdropEnabled: true,
      renderPanelSheet: true,
      backdropOpacity: 0.5,
      panelSnapping: false,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(60.0)),
      parallaxEnabled: true,
      parallaxOffset: 1,
      panel: Center(
        child: model==null?Container(
          child: RaisedButton(

            child: Text("Dashboard"),
            onPressed: (){
              Navigator.pushNamed(context, '/dashboard');
            },
          )
          ,):new PanelUi(model),
      ),
      collapsed: Container(),
      body: CupertinoPageScaffold(

        navigationBar: CupertinoNavigationBar(
          trailing: Icon(Icons.gps_fixed, size: 20,),
          middle: Text(
            "FOAM Maps",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ),

        child: MapUi(setModel: setModel,),
      ),
    );
  }


}