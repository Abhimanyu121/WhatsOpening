import 'package:http/http.dart'as http;
import 'dart:convert';
class ScannerWrapper{
  Future<Map> getDetails(String hash)async {
    print(hash);
    var url = "https://api-rinkeby.etherscan.io/api?module=transaction&action=gettxreceiptstatus&txhash="+hash+"&apikey=ZE2QGS32E2DTA2P37IXQG9Z5DT81QQV5C8";
    var resp =await http.get(url);
    print(resp.body);
    var jss= jsonDecode(resp.body);
    print("api:"+jss.toString());
    return jss;


  }
}
