import 'package:flutter/material.dart';
import 'package:flu/Widgets/BalanceCard.dart';
import 'package:flu/Wrappers/EthWrapper.dart';
import 'package:flu/Widgets/TransactionWidget.dart';

import '../Constants.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<Dashboard> {
  bool loading = true;
  double regBal;
  double voteBal;
  double totalBal;
  bool transacting = false;
  bool noTransactions = true;
  bool loading2 = true;
  String hash;
  Map json = {
    "result": {"status": "0"}
  };
  bool err = false;
  _getRegAllow() async {
    setState(() {
      loading = true;
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
    return Scaffold(
      floatingActionButton: Container(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          child: Icon(
            Icons.refresh,
            size: 40.0,
          ),
          onPressed: _getRegAllow,
          backgroundColor: Colors.black,
        ),
      ),
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white70),
      ),
      body: Container(
        color: nearlyWhite,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
              width: double.infinity,
              height: 180,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0.0),
                child: Text(
                  'User Dashboard',
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Column(
                children: <Widget>[
                  BalanceCard(reg: BigInt.from(regBal), voting: BigInt.from(voteBal), total: BigInt.from(totalBal),),
                  SizedBox(
                    height: 30,
                  ),
                  TransactionView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );

//                Center(
//                  child: CupertinoButton.filled(
//                    child: Icon(Icons.refresh),
//                    onPressed: _getRegAllow,
//                    borderRadius: BorderRadius.all(Radius.circular(68)),
//                  ),
//                ),
//
//
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text(
//                    "Your Balance",
//                    style: TextStyle(
//                        fontWeight: FontWeight.bold, color: Colors.black),
//                  ),
//                ),

//                Padding(// your balance wala container
//                  padding: const EdgeInsets.all(8.0),
//                  child: loading
//                      ? SpinKitFadingCircle(size: 50, color: Colors.blue)
//                      : BalanceCard(
//                          reg: BigInt.from(regBal),
//                          voting: BigInt.from(voteBal),
//                          total: BigInt.from(totalBal),
//                        ),
//                )
  }
}
