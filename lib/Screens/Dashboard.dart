import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flu/Widgets/BalanceCard.dart';
import 'package:flu/Wrappers/EthWrapper.dart';
import 'package:flu/Widgets/TransactionWidget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants.dart';
import '../ThemeData.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => new DashboardState();

}
class DashboardState extends State<Dashboard> {
  void _showcontent(){
    showDialog(
        context: context,
        barrierDismissible: true,
    builder: (BuildContext){
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: new Text('Private Key:'),
      content: new SingleChildScrollView(
      child: new ListBody(
      children: [
      new Text('6843DC59D41289CC20E905180F6702621DCB9798B4413C031F8CB6EF0D9FC3E0'),
      ],
      ),
      ),
        actions:[

          new FlatButton(
              child: new Text('Copy'),
              onPressed: (){
            ClipboardManager.copyToClipBoard(
                "6843DC59D41289CC20E905180F6702621DCB9798B4413C031F8CB6EF0D9FC3E0").then((result){
              final snackBar=SnackBar(
                content: Text('copy to clipboard'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: (){},
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            } );

          } )

        ],

      );
    }
    );
  }
  bool loading = true;
  double regBal;
  double voteBal;
  double totalBal;
  bool transacting = false;
  bool noTransactions = true;
  bool loading2 = true;
  String address="";
  String pvt="";
  String hash;
  Map json = {
    "result": {"status": "0"}
  };
  bool err = false;
  _getRegAllow  (
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //var pvt = prefs.getString("privateKey");
  //var address = await credentials.extractAddress();
  ) async {
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
          height: 50,
          width: 50,
          child: FloatingActionButton(
            child: Icon(
              Icons.refresh,
              size: 30.0,
            ),
            onPressed: _getRegAllow,
            backgroundColor: Colors.black,
          ),
        ),
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white70),
        ),
        body:
           Container(
            color: nearlyWhite,
            height: double.infinity,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      color: Colors.black,
                      width: double.infinity,
                      height: 100,
                      child: Padding(
                       padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
                        child: Text(
                          'User Dashboard',
                          style: TextStyle(
                            fontSize: 35.0,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top:40,
                  left: 40,
                  right: 40,
                  child: loading?SpinKitFadingCircle(size:50, color:Colors.blue): Scrollbar(

                    child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        BalanceCard(reg: BigInt.from(regBal), voting: BigInt.from(voteBal), total: BigInt.from(totalBal),),
                      SizedBox(
                        height: 5.0,
                      ),
                        TransactionView(),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width*0.7,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [AppTheme.nearlyWhite, HexColor("#FFFFFF")],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.6),
                                    offset: Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0,80.0,10.0,0.0),
                              child: Center(
                                child: MaterialButton(
                                  shape: Border.all(width: 1.0, color: Colors.blueGrey),
                                  color: Colors.black,
                                  child: Text(
                                      'Reveal PrivateKey',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: _showcontent,


                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
