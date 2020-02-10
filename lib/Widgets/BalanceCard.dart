import 'package:flu/Wrappers/EtherscanWrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../ThemeData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class BalanceCard extends StatefulWidget{
  BigInt reg;
  BigInt voting;
  BigInt total;
  BalanceCard({this.reg, this.voting, this.total});

  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool transacting =false;
  bool noTransactions= true;
  bool loading = true;
  String hash;
  Map json={"result":{"status":"0"}};
  bool err =false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppTheme.nearlyDarkBlue,
            HexColor("#1d59d5")
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
              Text("Your Tokens : \n\t\t"+widget.total.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
              SizedBox(
                height: 10,
              ),
              Text("Your Approved Tokens :", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Registry",style: TextStyle(fontWeight:  FontWeight.bold, color: Colors.black),),
                      widget.reg==BigInt.from(0)?Text("0"): Text(widget.reg.toString(),style: TextStyle(fontWeight:  FontWeight.bold, color: Colors.black),)
                    ],
                  ),

                  Column(
                    children: <Widget>[
                      Text("Voting",style: TextStyle(fontWeight:  FontWeight.bold, color: Colors.black),),
                      widget.voting==BigInt.from(0)?Text("0"): Text(widget.voting.toString(),style: TextStyle(fontWeight:  FontWeight.bold, color: Colors.black),),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: CupertinoButton.filled(
                  child: Text("Change Allowances"),
                  onPressed: () async {
                    await _transactionStatus().then((val){

                      if(transacting){

                        Toast.show("Another Transaction is in progress",context, duration: Toast.LENGTH_LONG);
                      }
                      else{
                        Navigator.pushNamed(context, '/allowance');

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
        await  wrapper.getDetails(hash).then((jss) async {

          print("checking:"+jss.toString());
          setState(() {
            json =jss;
          });
          jos =jss;
          await _check();
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
