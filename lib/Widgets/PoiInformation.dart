import 'package:flu/Models/POIModel.dart';
import 'package:flu/Screens/Map.dart';
import 'package:flu/Wrappers/EthWrapper.dart';
import 'package:flu/Wrappers/EtherscanWrapper.dart';
import 'package:flutter/material.dart';
import 'package:flu/ThemeData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PoiWidget extends StatefulWidget{
  GlobalKey<MapState> mapState;
  POIModel model;
  PoiWidget({this.model, this.mapState});
  @override
  PoiWidgetState createState() => new PoiWidgetState();
}
class PoiWidgetState extends State<PoiWidget>{
  bool _loading = true;
  bool bal;
  TextEditingController amount = TextEditingController();
  TextEditingController reason = TextEditingController();
  bool transacting =false;
  bool noTransactions= true;
  bool loading = true;
  String hash;
  Map json={"result":{"status":"0"}};
  bool err =false;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  _fetchBal()async {
    EthWrapper wrapper= new EthWrapper();
    double bal = await  wrapper.regAllow();
    return bal;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBal().then((val){
      setState(() {
        this.bal = val>=100;
        _loading = false;
      });
    });
  }
  Widget lessBal = Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          //color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppTheme.nearlyDarkBlue,
                HexColor("#6F56E8")
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topRight: Radius.circular(8.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: AppTheme.grey.withOpacity(0.6),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Not Enough Approved Tokens", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                  SizedBox(
                    height: 10,
                  ),
                  Text("To be able to Challenge POI, you need to stake minimum 100FOAM tokens. You can Approve tokens in dashboard, and then try again.",style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _loading?SpinKitFadingCircle(size:50, color:Colors.blue):!bal?lessBal: Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppTheme.nearlyDarkBlue,
            HexColor("#6F56E8")
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(68.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppTheme.grey.withOpacity(0.6),
                offset: Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Name : \n\t\t"+widget.model.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
              SizedBox(
                height: 10,
              ),
              Text("GeoHash :\n\t\t"+widget.model.geoHash, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
              SizedBox(
                height: 10,
              ),
              Text("Owner :\n\t\t"+widget.model.owner, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: amount,
                    autovalidate: true,
                    validator: (val) => val==""?null:(double.parse(val)<=100?
                    "Invalid amount, Should be at least 100":
                    null),
                    obscureText: false,
                    style: style,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15,10,15,10),
                        hintText: "Tokens to put on stake",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: reason,
                    obscureText: false,
                    style: style,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15,10,15,10),
                        hintText: "Reason for challenge",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: OutlineButton(
                  child: Text("Challenge"),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Toast.show("Please wait..", context);
                    await _transactionStatus().then((val)async {

                      if(transacting){

                        Toast.show("Another Transaction is in progress",context, duration: Toast.LENGTH_LONG);
                      }
                      else{
                        Toast.show("Please wait..", context);
                        EthWrapper wrapper = new EthWrapper();
                        await wrapper.newChallenge(widget.model.listingHash, double.parse(amount.text), reason.text);
                        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);

                      }
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  _transactionStatus()async {
    await SharedPreferences.getInstance().then((prefs)async {
      var jos;
      bool transaction = prefs.getBool("transacting");
      String hash= prefs.getString("hash");
      //hash = "0x27fc3579c8fc51d1d9d673ee36efea8d0f5b2237579fd4a5d757326f5805c1fc ";
      if(transaction ==true){
        setState(() {
          transacting =true;
        });
      }else{
        setState(() {
          transacting= false;
        });}
      if(hash ==""||hash==null){
        setState(() {
          noTransactions = true;
        });
        Map mv ={"status":"0"};
        setState(() {
          loading =false;
        });
        return mv;
      }else{
        setState(() {
          this.hash = hash;
          noTransactions =false;
        });

        print("here");
        ScannerWrapper wrapper = new ScannerWrapper();
        await  wrapper.getDetails(hash).then((jss){

          print("checking:"+jss.toString());
          setState(() {
            json =jss;
          });
          jos =jss;
          _check();
          setState(() {
            loading =false;
          });
          return jss;
        });
      }
      return jos;
    });
  }
  _check()async{
    if(json["result"]["status"]=="1"||json["message"]=="NOTOK"){
      await SharedPreferences.getInstance().then((prefs){
        setState(() {
          transacting=false;
          print("transaction mereged");
          print("check2:"+transacting.toString());
        });
        prefs.setBool("transacting", false);
      });

    }
    if(json["message"]=="NOTOK"||json["result"]["status"]=="0"){
      setState(() {
        print("Transaction failed");
        transacting =false;
        err= true;
      });
      print("err: check"+err.toString());
    }
  }

}