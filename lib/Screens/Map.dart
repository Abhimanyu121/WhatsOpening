import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flu/Models/POIModel.dart';
import 'package:geohash/geohash.dart';
import 'package:flu/Wrappers/MapBoxApiWrapper.dart';
class MapUi extends StatefulWidget{
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
    target: LatLng(6.453666714951396, 3.430313151329756),
    zoom: 11.0,
  );

  void _selectCircle(Circle circle) {
    print("here");
    var latitude = circle.options.geometry.latitude;
    var longitude = circle.options.geometry.longitude;
    var hash = Geohash.encode(latitude, longitude);
    print(hash);
    setState(() {
      selected = mapping[hash.substring(0, 3)];
    });
    print(selected.name);
  }

  _fetchPOI() async {
    MapBoxApiWrapper wrapper = new MapBoxApiWrapper();
    var tupple = await wrapper.getPOI(0, 0, 0, 0);
    var ls = tupple[0];
    setState(() {
      dots = ls;
      mapping = tupple[1];
    });
    print(Geohash
        .decode(ls[1].geoHash)
        .x);
    print(Geohash
        .decode(ls[1].geoHash)
        .y);
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
    setState(() {
      _extractMapInfo();
    });
  }

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    mapController.onCircleTapped.add(_selectCircle);
  }

  @override
  Widget build(BuildContext context) {
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
          circleColor: "#FF0000",
          circleRadius: 10,

        ));

      }

    }
    return MapboxMap(
      initialCameraPosition: _kInitialPosition,
      compassEnabled: true,
      onMapCreated: _onMapCreated,
    );
  }
}