import 'package:flu/Models/ArgListPanelChallege.dart';
import 'package:flu/Widgets/PoiInformation.dart';
import 'package:flutter/material.dart';
import 'package:flu/Wrappers/EthWrapper.dart';
import 'package:flu/Wrappers/EtherscanWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ChallengeScreen extends StatefulWidget{
  final routeName = '/ChallengeScreen';
  @override
  ChallengeScreenState createState() => new ChallengeScreenState();

}
class ChallengeScreenState extends State<ChallengeScreen>{
  bool loading = true;
  double regBal;
  double voteBal;
  double totalBal;
  bool transacting =false;
  bool noTransactions= true;
  bool loading2 = true;
  String hash;
  Map json={"result":{"status":"0"}};
  bool err =false;
  _getRegAllow() async {
    setState(() {
      loading= true;
    });
    EthWrapper wrapper = new EthWrapper();
    var regBal = await wrapper.balances();
    setState(() {
      loading = false;
      this.regBal = regBal[0];
      this.voteBal = regBal[1];
      this.totalBal = regBal[2];
    });
  }
  @override
  void initState() {
    super.initState();
    _getRegAllow();
  }
  @override
  Widget build(BuildContext context) {

    final ArgListPanelChallenge args = ModalRoute.of(context).settings.arguments;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "Challenge",
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Row(children: <Widget>[
              Text(
                "  ",
              ),
            ]),
            Row(
              children: <Widget>[
                Text(
                  "Place",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 26.0,
                  ),
                )
              ],
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body:Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Challenge the POI", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PoiWidget(model: args.model,mapState: args.key,),
                ),
              ],

            ),
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
          loading2 =false;
        });
        return mv;
      }else{
        setState(() {
          this.hash = hash;
          noTransactions =false;
        });

        print("here");
        ScannerWrapper wrapper = new ScannerWrapper();
        await  wrapper.getDetails(hash).then((jss) async {

          print("checking:"+jss.toString());
          setState(() {
            json =jss;
          });
          jos =jss;
          await _check();
          setState(() {
            loading2 =false;
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
        print("transaction mereged");
        transacting =false;
        err= true;
      });
      print("err: check"+err.toString());
    }
  }

}