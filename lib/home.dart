import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geohash/geohash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flu/Screens/Map.dart';
import 'package:flu/Models/POIModel.dart';
import 'package:flu/Screens/Panel.dart';
import 'package:flu/Screens/StaticFOAMinfo.dart';
class Home extends StatefulWidget{

  HomeState createState() => HomeState();
}
class HomeState extends State<Home>{
  POIModel model;
  bool mode = true;
  MapUi map;
  bool selection = false;
  CameraPosition _pos;

  setModel(POIModel model){
    setState(() {
      this.model = model;
      this.selection = false;
    });
  }
  _refresh(){
    this.model = null;

  }
  @override
  void initState() {
    super.initState();
    _pos = const CameraPosition(
      target: LatLng(28.7041, 77.1025),
      zoom: 11.0,
    );
    map = MapUi(setModel: setModel,kInitialPosition: _pos,);
  }

  @override
  Widget build(BuildContext context) {
    Widget addPOI = new Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Add new Point of Interest?\nMove place under the pin", style: TextStyle(color: Colors.black),),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.4,
              child: CupertinoButton.filled(

                child: Text("Add POI"),
                onPressed:()  {
                  var encoded =  Geohash.encode(map.mapController.cameraPosition.target.latitude,map.mapController.cameraPosition.target.longitude);
                  Navigator.pushNamed(context, '/AddPoi',arguments: encoded);
                },
              ),
            )


          ],
        )
    );
    final GlobalKey<MapState> _MapState = GlobalKey<MapState>();
    final double _initFabHeight = 120.0;
    double _fabHeight = 120.0;
    double _panelHeightOpen;
    double _panelHeightClosed = 95.0;
    return SlidingUpPanel(
      backdropTapClosesPanel: true,
      backdropEnabled: true,
      renderPanelSheet: true,
      backdropOpacity: 0.5,
      panelSnapping: false,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      parallaxEnabled: true,
      parallaxOffset: 1,
      onPanelSlide: (double pos) => setState((){
        _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
      }),
      panel: Center(
        child: model==null?FoamInfo():new PanelUi(model,_MapState,_refresh),
      ),
      collapsed: model==null?selection?addPOI:Container(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Center(

                  child: Text("Welcome to FOAM Maps", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 20),
                  )),
            ),
          ),
        ),
      ): Container(),
      body: CupertinoPageScaffold(

        navigationBar: CupertinoNavigationBar(

          middle: Text(
            "FOAM Maps",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

        ),

        child: Stack(

            children:[
              map  ,
              Positioned(
                right: 20.0,
                bottom: _fabHeight,
                child: FloatingActionButton(
                  heroTag: "asd",
                  child: Icon(
                    Icons.gps_fixed,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: ()async {
                    var pos =  await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                    CameraUpdate cu = CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos.latitude,pos.longitude,),zoom: 10));
                    map.mapController.moveCamera(cu);
                  },
                  backgroundColor: Colors.white,
                ),
              ),
              Positioned(
                left: 20.0,
                bottom: _fabHeight,
                child: FloatingActionButton(
                  heroTag: "sddf",
                  child: !selection?Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                  ):Icon(
                    Icons.close,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      if(selection){
                        selection = false;
                      }else{
                        model=null;
                        selection = true;
                      }

                    });
                  },
                  backgroundColor: Colors.white,
                ),
              ),
              !selection ?Container():Align(
                alignment: Alignment.center,
                child: FloatingActionButton(
                  heroTag: "qwe",
                  child: Image.asset("assets/pin.png",scale: 0.0001,),
                  onPressed: () {
                    setState(() {
                      model=null;
                      selection = true;
                    });
                  },
                  backgroundColor: Colors.transparent,
                ),

              ),

              Positioned(

                top: MediaQuery.of(context).size.height*0.13,
                left: MediaQuery.of(context,).size.width *0.3,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24.0, 6.0, 24.0, 6.0),
                  child: FlatButton(
                    onPressed: ()async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var pvt = prefs.getString("privateKey");
                      if(pvt!=null){
                        Navigator.pushNamed(context, '/dashboard');
                      }
                      else{
                        Navigator.pushNamed(context, '/LoginWithoutSkip');
                      }

                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.account_circle),
                        Text(
                          "Dashboard",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .25),
                        blurRadius: 16.0
                    )],
                  ),
                ),
              ),


            ]
        ),
      ),
    );
  }


}