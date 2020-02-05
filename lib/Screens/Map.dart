import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flu/Models/POIModel.dart';
import 'package:geohash/geohash.dart';
import 'package:flu/Wrappers/MapBoxApiWrapper.dart';
class MapUi extends StatefulWidget{
  Function(POIModel) setModel;
  MapUi({this.setModel});
  @override
  MapState createState() => new MapState();
}
class MapState extends State<MapUi> {
  MapboxMapController mapController;
  CameraPosition _position = _kInitialPosition;
  List dots;
  Map mapping;
  POIModel selected;
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(28.7041, 77.1025),
    zoom: 11.0,
  );

  void _selectCircle(Circle circle) {
    print("here");
    var latitude = circle.options.geometry.latitude;
    var longitude = circle.options.geometry.longitude;
    var hash = latitude.toString()+longitude.toString();
    print(hash);
    print("at child");
    selected = mapping[hash];
    print(selected.name);
    widget.setModel(selected);
  }

  _fetchPOI() async {
    if(dots == null ){
      MapBoxApiWrapper wrapper = new MapBoxApiWrapper();
      await wrapper.getPOI(0, 0, 0, 0).then((tupple){
        setState(() {
          dots = tupple[0];
          mapping = tupple[1];
        });
        if (dots != null && mapController != null) {
          for (int i = 0; i < dots.length; i++) {
            mapController.addCircle(CircleOptions(

              geometry: LatLng(
                Geohash
                    .decode(dots[i].geoHash)
                    .x,
                Geohash
                    .decode(dots[i].geoHash)
                    .y,
              ),
              circleColor: "#2196F3",
              circleRadius: 5,

            ));

          }

        }
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchPOI();
  }

  _extractMapInfo() {
    _position = mapController.cameraPosition;
  }

  void _onMapChanged() {
    _extractMapInfo();
  }

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    mapController.onCircleTapped.add(_selectCircle);
  }

  @override
  Widget build(BuildContext context) {

    return MapboxMap(
      initialCameraPosition: _kInitialPosition,
      compassEnabled: true,
      onMapCreated: _onMapCreated,
    );
  }
}