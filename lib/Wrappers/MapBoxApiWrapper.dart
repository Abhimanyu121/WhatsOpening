import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flu/Models/POIModel.dart';
import 'package:geohash/geohash.dart';
class MapBoxApiWrapper {
  Future<List> getPOI(double swLat, double swLon, double neLat, double neLon ) async {
     const  url = "https://map-api-direct.foam.space:443/poi/map?swLng=72.5714&swLat=23.0225&neLng=78.0322&neLat=30.3165";
     var resp = await http.get(url);
     print(resp.body);
     var  json = List.from(jsonDecode(resp.body));
     List<POIModel> list= new List<POIModel>();
     Map<String, POIModel> map  = new Map<String, POIModel>();
     for (int i =0; i<json.length; i++){
       POIModel model = new POIModel();
       model.name = json[i]["name"];
       model.geoHash = json[i]["geohash"];
       var tags = List.from(json[i]["tags"]);
       print(tags);
       model.tags = tags;
       print("putting in map");
       print(json[i]["geohash"].toString().substring(0,4));
       var latlang = Geohash.decode(json[i]["geohash"].toString());
       map[latlang.x.toString()+latlang.y.toString()] = model;
       list.add(model);
     }
    return [list, map];
  }
}