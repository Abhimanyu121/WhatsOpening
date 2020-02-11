import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flu/Models/POIModel.dart';
import 'package:geohash/geohash.dart';
import 'package:flu/Wrappers/MapBoxApiWrapper.dart';
import 'package:geolocator/geolocator.dart';
class MapUi extends StatefulWidget{
  Function(POIModel) setModel;
  MapUi({this.setModel, Key key}):super(key: key);
  @override
  MapState createState() => new MapState();
}
class MapState extends State<MapUi> {
  MapboxMapController mapController;
  CameraPosition _position = _kInitialPosition;
  MapBoxApiWrapper wrapper;
  List dots;
  Map mapping;
  var lat;
  var lng;
  POIModel selected;
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(28.7041, 77.1025),
    zoom: 11.0,
  );
  getLoc()async {
    var pos =  await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("current loc");
    print(pos.latitude.toString()+pos.longitude.toString());
    return pos;
  }
  void _selectCircle(Symbol symbol) {
    print("here");
    var latitude = symbol.options.geometry.latitude;
    var longitude = symbol.options.geometry.longitude;
    var hash = latitude.toString()+longitude.toString();
    print(hash);
    print("at child");
    selected = mapping[hash];
    print(selected.name);
    widget.setModel(selected);
  }
  refresh(){
    wrapper.clear();
    widget.setModel(null);
    getLoc().then((pos){
      _fetchPOI(pos).then((a){

      });
    });

  }
  _fetchPOI(Position pos) async {
    if(dots == null ){
      CameraUpdate cu = CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos.latitude,pos.longitude,),zoom: 10));
      mapController.moveCamera(cu);
      mapController.addSymbol(SymbolOptions(
          geometry: LatLng(
              pos.latitude,
              pos.longitude
          ),
          iconImage: "assets/pinkmark.png",
          iconSize: 1,
          iconColor: "#00F0F8FF"
      ));
      wrapper = new MapBoxApiWrapper();
      await wrapper.getPOI(pos.latitude, pos.longitude).then((tupple){
        setState(() {
          dots = tupple[0];
          mapping = tupple[1];
        });
        if (dots != null && mapController != null) {
          for (int i = 0; i < dots.length; i++) {
            mapController.addSymbol(SymbolOptions(
              geometry: LatLng(
                Geohash
                    .decode(dots[i].geoHash)
                    .x,
                Geohash
                    .decode(dots[i].geoHash)
                    .y,
              ),
              iconImage: "assets/blumark.png",
              iconSize: 0.1,
              iconColor: "#00F0F8FF"
            ));

          }

        }
      });
    }
    return 0;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  _extractMapInfo() async  {
    _position = mapController.cameraPosition;
    var tupple = await wrapper.getPOI(_position.target.latitude, _position.target.longitude);
    if(tupple.length !=0){
      List<POIModel> ls =tupple[0];
      for(int i =0; i <ls.length;i++) {
        var latlang = Geohash.decode(ls[i].geoHash.toString());
        var key = latlang.x.toString()+latlang.y.toString();
        if (mapping[key]==null){
          dots.add(ls[i]);
          mapping[key]= ls[i];
          mapController.addSymbol(SymbolOptions(
              geometry: LatLng(
                Geohash
                    .decode(ls[i].geoHash)
                    .x,
                Geohash
                    .decode(ls[i].geoHash)
                    .y,
              ),
              iconImage: "assets/blumark.png",
              iconSize: 0.1,
              iconColor: "#00F0F8FF"
          ));
        }
      }
    }
   // print(_position.toString());
  }

  void _onMapChanged() {
    _extractMapInfo();
  }

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    mapController.onSymbolTapped.add(_selectCircle);
    getLoc().then((pos){
      _fetchPOI(pos).then((a){

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return MapboxMap(
      trackCameraPosition: true,
      initialCameraPosition: _kInitialPosition,
      compassEnabled: true,
      onMapCreated: _onMapCreated,
    );
  }
}