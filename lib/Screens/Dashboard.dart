import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flu/Widgets/BalanceCard.dart';
import 'package:flu/Widgets/AllowanceRegistry.dart';
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
            "FOAM Maps",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
      ),
      child:Container(
        //color:  Color(0xFFEDF0F2),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Change Allowances", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                  RegistryAllow(),
                ],

              ),
          ),
        ),
      ),

    );
  }

}