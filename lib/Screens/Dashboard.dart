import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flu/Widgets/BalanceCard.dart';
import 'package:flu/Widgets/AllowanceRegistry.dart';
import 'package:flu/Wrappers/EthWrapper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flu/Widgets/TransactionWidget.dart';
import 'package:flu/Wrappers/EtherscanWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Dashboard extends StatefulWidget{
  @override
  DashboardState createState() => new DashboardState();

}
class DashboardState extends State<Dashboard>{
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
    EthWrapper wrapper = new EthWrapper();
    var regBal = await wrapper.regAllowance();
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
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          trailing: Icon(Icons.gps_fixed, size: 20,),
          middle: Text(
            "Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
      ),
      child:Container(
        color: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Your Last Transaction", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TransactionView(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Your Balance", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  loading?SpinKitDualRing(size: 10, color: Colors.blue,):BalanceCard(reg: BigInt.from(regBal), voting: BigInt.from(voteBal),total: BigInt.from(totalBal),),


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
    if(json["result"]["status"]=="1"||json["message"]=="NOTOK"||json["result"]["Status"]=="0"){
      await SharedPreferences.getInstance().then((prefs){
        setState(() {
          transacting=false;
          print("transaction mereged");
          print("check2:"+transacting.toString());
        });
        prefs.setBool("transacting", false);
      });

    }
    if(json["message"]=="NOTOK"||json["result"]["Status"]=="0"){
      setState(() {
        print("transaction mereged");
        transacting =false;
        err= true;
      });
      print("err: check"+err.toString());
    }
  }

}