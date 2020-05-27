import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flu/Constants.dart';
import 'package:flu/Wrappers/KeyInterfaces.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:web3dart/credentials.dart';
class LoginWithSkip extends StatefulWidget{
  @override
  LoginWithSkipState createState() => new LoginWithSkipState();

}
class LoginWithSkipState extends State<LoginWithSkip> {

  bool walletStatus = true;
  String privateKey = "";
  String address="";
  var walletBalance = "0";
  _checkWalletStatus() async {
    setState(() {
      walletStatus =false;
    });
    print("inside check status");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("email")==null||prefs.getString("email")==""){
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      print(user.email);
      prefs.setString("email",user.email);
      prefs.setString("user", user.displayName);
    }
    var key = prefs.getString("privateKey");
    if(key =="" || key ==null){
      await Firestore.instance
          .collection('walletUsers')
          .document(prefs.getString("email"))
          .get()
          .then((DocumentSnapshot ds)async  {
        if(!ds.exists){
          var keygen = await KeyInterface.generateKey();
          print("pvtkey:$keygen");
          var addr = prefs.getString("address");
          await Firestore.instance.collection('walletUsers').document(prefs.getString("email"))
              .setData({ "privateKey": keygen[0],"address": addr});

          setState(() {
            walletStatus =true;
            address = addr;
            privateKey = keygen[0];
          });
          prefs.setBool("loggedIn", true);
          prefs.setString("address", keygen[1]);
          prefs.setString("privateKey", keygen[0]);
          Navigator.popAndPushNamed(context,'/home');
        }else {
          await prefs.setString("privateKey", ds["privateKey"]);
          await prefs.setString("address", ds["address"]);
          await  prefs.setBool("loggedIn", true);
          print("fstore"+ds["address"].toString());
          setState(() {
            walletStatus = true;
            address = ds["address"];
            privateKey = ds["privateKey"];
          });
          Navigator.popAndPushNamed(context,'/home');
        }
      });

    }
    else {
      var addr = prefs.getString("address");
      setState(() {
        address = addr;
        privateKey = key;
      });
      prefs.setString("address", addr);
      prefs.setString("privateKey", key);
      prefs.setBool("loggedIn", true);
      Navigator.popAndPushNamed(context,'/home');
    }
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController pvt = new TextEditingController();
    // TODO: implement build
    return Scaffold(

      body: Center(
        child: walletStatus?Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(

              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    Hero(
                      tag: 'hero',
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 48.0,
                        child: Image.asset('assets/blumark.png'),
                      ),
                    ),
                    Center(
                      child: Card(
                        elevation: 0,
                        color:Colors.white ,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            autovalidate: true,
                            validator: (val) => (val.length<64&&val.isNotEmpty)
                                ? 'Invalid private key'
                                : null,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: 'Private key',
                              labelText: 'Private key',
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
                            ),
                            controller: pvt,
                          ),
                        ),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        borderSide: BorderSide(
                          color: Colors.blue
                        ),
                        child: Text("Login with Private Key"),
                        onPressed: ()async {
                          if(pvt.text.length == 64){
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("privateKey",pvt.text);
                            Credentials credentials = EthPrivateKey.fromHex(pvt.text.trim());
                            var _addr = await credentials.extractAddress();
                            prefs.setBool("loggedIn", true);
                            prefs.setString("address",_addr.hex);
                            Navigator.popAndPushNamed(context,'/home');
                          }
                          else{Toast.show("Invalid private key",context);}
                        },

                      ),
                    ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Divider(
                           thickness: 10,
                           color: Colors.black,
                         ),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text("OR",style: TextStyle(color: Colors.black87),),
                         ),
                         Divider(
                           color: Colors.black,
                           thickness: 10,
                         ),
                       ],
                     ),
                   ),

                    OutlineButton(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                      child: Text(
                        'Login with Google',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                      onPressed:_checkWalletStatus,

                    )
                  ],
                ),
              ),
            )
          ),
        ):  SpinKitCubeGrid(
          size: 50,
          color: appTheme,
        ),
      ),

    );
  }

}