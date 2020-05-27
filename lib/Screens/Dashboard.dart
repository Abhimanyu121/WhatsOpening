
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flu/Widgets/BalanceCard.dart';
import 'package:flu/Wrappers/EthWrapper.dart';
import 'package:flu/Widgets/TransactionWidget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../Constants.dart';
import '../ThemeData.dart';

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
  String address="";
  String pvt="";
  String hash;
  Map json = {
    "result": {"status": "0"}
  };
  bool err = false;
  _getRegAllow  () async {
    setState(() {
      loading = true;
    });
    EthWrapper wrapper = new EthWrapper();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _pvt = prefs.getString("privateKey");
    var _addr = prefs.getString("address");

    var regBal = await wrapper.balances();
    setState(() {
      loading = false;
      this.regBal = regBal[0];
      this.voteBal = regBal[1];
      this.totalBal = regBal[2];
      address = _addr;
      pvt = _pvt;

    });
  }

  @override
  void initState() {
    super.initState();
    _getRegAllow();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height*0.06;
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
          brightness: Brightness.light,
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
                Positioned(
                  top: 0,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.2,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.black,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height*0.18,
                          child: Padding(
                           padding:  EdgeInsets.fromLTRB(10.0, height, 10.0, 0.0),
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
                  ),
                ),
                Positioned(
                  top:MediaQuery.of(context).size.height*0.12,
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
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          height: 210,
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
                            padding: const EdgeInsets.fromLTRB(15.0,15.0,15.0,0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("Your Address:", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    IconButton(
                                      icon: Icon(Icons.content_copy),
                                      color: Colors.black38,
                                      onPressed: (){
                                        Clipboard.setData(
                                            ClipboardData(text:address)).then((result){
                                          Toast.show("Address Copied",context);
                                        } );
                                      },
                                    )
                                  ],
                                ),
                                Text(address, style: TextStyle(color: Colors.black87),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                  ],
                                ),
                              ],
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
  }
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
                  Text(pvt),
                ],
              ),
            ),
            actions:[

              new FlatButton(
                  child: new Text('Copy'),
                  onPressed: (){
                    Clipboard.setData(
                        ClipboardData(text:pvt)).then((result){
                      Toast.show("Private Key Copied",context);
                    } );

                  } ),
              new FlatButton(
                  child: new Text('Back'),
                  onPressed: (){
                   Navigator.pop(context);

                  } )

            ],

          );
        }
    );
  }
}
