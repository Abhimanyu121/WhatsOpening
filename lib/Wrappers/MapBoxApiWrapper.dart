import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flu/Models/POIModel.dart';
class MapBoxApiWrapper {
  Future<List> getPOI(double swLat, double swLon, double neLat, double neLon ) async {
     const  url = "https://map-api-direct.foam.space/poi/map?swLng=0&swLat=0&neLng=75.7873&neLat=26.9124&offset=2";
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

       map[json[i]["geohash"].toString().substring(0,3)] = model;;
       list.add(model);
     }
    return [list, map];
  }
}