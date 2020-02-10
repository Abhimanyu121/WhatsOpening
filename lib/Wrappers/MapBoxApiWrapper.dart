import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flu/Models/POIModel.dart';
import 'package:geohash/geohash.dart';
class MapBoxApiWrapper {
  double nelat ;
  double nelong ;
  double swlat ;
  double swlong ;
  Future<List> getPOI(double lat, double long ) async {

    if(this.nelat ==null){
      print("in the wrapper");
      nelat = lat +10;
      nelong = long +10;
      swlat = lat -10;
      swlong = long -10;
      var  url = "https://rink-cd-api.foam.space/poi/map?swLng="+swlong.toString()+"&swLat="+swlat.toString()+"&neLng="+nelong.toString()+"&neLat="+nelat.toString();
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
    else if(nelat - lat >10||nelat - lat <-10||nelong - long >10||nelong - long >10){
      print("in the wrapper2");
      nelat = lat +10;
      nelong = long +10;
      swlat = lat -10;
      swlong = long -10;
      var  url = "https://rink-cd-api.foam.space/poi/map?swLng="+swlong.toString()+"&swLat="+swlat.toString()+"&neLng="+nelong.toString()+"&neLat="+nelat.toString();
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
    else{
      return[];
    }

  }
}