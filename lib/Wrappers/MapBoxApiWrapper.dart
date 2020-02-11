import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flu/Models/POIModel.dart';
import 'package:geohash/geohash.dart';
class MapBoxApiWrapper {
  double nelat ;
  double nelong ;
  double swlat ;
  double swlong ;
  double lat;
  double long;
  static bool instance = false;
  Future<List> getPOI(double lat, double long ) async {

    if(nelong == null ){
      print("in the wrapper");
      instance = true;
      this.lat= lat;
      this.long = long;
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
        model.state = json[i]["state"]["status"]["type"];
        model.listingHash = json[i]["listingHash"];
        model.owner = json[i]["owner"];
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
    else if(this.lat - lat >10||this.lat - lat < -10||this.long - long >10||this.long - long < -10){
      print("condition check");
      print(nelat - lat >10);
      print(nelat - lat < -10);
      print(nelong - long >10);
      print(nelong - long < -10);
      print("in the wrapper2");
      this.lat= lat;
      this.long = long;
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
        model.listingHash = json[i]["listingHash"];
        model.state = json[i]["state"]["status"]["type"];
        model.owner = json[i]["owner"];
        print("check state 2");
        print(model.state);
        var tags = List.from(json[i]["tags"]);
        print(tags);
        model.tags = tags;
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
  void clear(){
    instance = false;
  }
}