import 'package:flu/Wrappers/EthWrapper.dart';
import 'package:flu/Wrappers/EtherscanWrapper.dart';
import 'package:flu/Wrappers/MapBoxApiWrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../ThemeData.dart';
class NewPoi extends StatefulWidget{
  @override
  NewPoiState createState() => new NewPoiState();
}
class NewPoiState extends State<NewPoi>{
  bool _loading = true;
  bool bal;
  bool transacting =false;
  bool noTransactions= true;
  bool loading = true;
  String hash;
  Map json={"result":{"status":"0"}};
  bool err =false;
  final List<String> _cast = <String>[
    "Art",
    "Blockchain",
    "Food",
    "Work",
    "Education",
    "Retail"
  ];
  Iterable<Widget> get tags sync* {
    for (String tg in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          avatar: CircleAvatar(child: Text(tg.substring(0,1)),),
          label: Text(tg),
          selected: _filters.contains(tg),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _filters.add(tg);
              } else {
                _filters.removeWhere((String name) {
                  return name == tg;
                });
              }
            });
          },
        ),
      );
    }
  }
  Widget lessBal = SizedBox(
    height: 200,
    child:Container(
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
                    Text("To be able to create POI, you need to stake minimum 100FOAM tokens. You can Approve tokens in dashboard, and then try again.",style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ) ,
  );
  _fetchBal()async {
    EthWrapper wrapper= new EthWrapper();
    double bal = await  wrapper.regAllow();
    return bal;
  }
  List<String> _filters = <String>[];
  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController amount = new TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    final String  geohash = ModalRoute.of(context).settings.arguments;
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: Text(
            "Add POI",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
      ),
      backgroundColor: Colors.black54,
      child: Center(
        child: _loading?SpinKitFadingCircle(size:50, color:Colors.blue):!bal?lessBal:ListView(

          children: <Widget>[

            SizedBox(
              height:550,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 0,
                    child: ListView(
                      children: <Widget>[
                        Container(

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Add New POI", style:TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  autovalidate: false,
                                  validator: (val) =>val.length==0
                                      ? 'Invalid Name'
                                      : null,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    hintText: 'Name',
                                    labelText: 'Name',
                                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
                                  ),
                                  controller: name,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  autovalidate: false,
                                  validator: (val) =>val.length==0||val ==null
                                      ? 'Invalid Address'
                                      : null,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    hintText: 'Address',
                                    labelText: 'Address',
                                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
                                  ),
                                  controller: address,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  autovalidate: false,
                                  validator: (val) =>val!=null||val.length<64
                                      ? 'Invalid Description'
                                      : null,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    hintText: 'Description',
                                    labelText: 'Description',
                                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
                                  ),
                                  controller: description,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  autovalidate: false,
                                  validator: (val) =>int.parse(val.toString())==0
                                      ? 'Invalid Name'
                                      : null,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    hintText: 'Amount',
                                    labelText: 'Amount',
                                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
                                  ),
                                  controller: amount,
                                ),
                              ),
                              Wrap(
                                children: tags.toList(),
                              ),
                              CupertinoButton.filled(
                                child: Text("Submit POI"),
                                onPressed: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  Toast.show("Please wait..", context);
                                  await _transactionStatus().then((val)async {

                                    if(transacting){

                                      Toast.show("Another Transaction is in progress",context, duration: Toast.LENGTH_LONG);
                                    }
                                    else{
                                      MapBoxApiWrapper mWrapper = new MapBoxApiWrapper();
                                      var ipfs = await mWrapper.addPoi(geohash, address.text, name.text, description.toString(), _filters);
                                      print(ipfs);
                                      EthWrapper eWrapper = new EthWrapper();
                                      var status = await eWrapper.addPOI(geohash, double.parse(amount.text), ipfs);
                                      if(status){
                                        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
                                      }
                                    }
                                  });

                                },
                              )

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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