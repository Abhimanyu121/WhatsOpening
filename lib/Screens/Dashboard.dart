import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flu/Widgets/BalanceCard.dart';
import 'package:flu/Wrappers/EthWrapper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flu/Widgets/TransactionWidget.dart';
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
                  Center(
                    child: CupertinoButton.filled(child: Icon(Icons.refresh), onPressed:_getRegAllow, borderRadius: BorderRadius.all(Radius.circular(68)),),
                  ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: loading?SpinKitFadingCircle(size:50, color:Colors.blue):BalanceCard(reg: BigInt.from(regBal), voting: BigInt.from(voteBal),total: BigInt.from(totalBal),),

                  )
                  
                ],

              ),
          ),
        ),
      ),

    );
  }

}