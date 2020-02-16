import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginWithoutSkip extends StatefulWidget{
  @override
  LoginWithoutSkipState createState() => new LoginWithoutSkipState();

}
class LoginWithoutSkipState extends State<LoginWithoutSkip> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController pvt = new TextEditingController();
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar:  CupertinoNavigationBar(
          middle: Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
      ),
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(

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
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          autovalidate: true,
                          validator: (val) => val.length<64
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
                    RaisedButton(
                      child: Text("Continue"),
                      onPressed: ()async {
                        if(pvt.text.length == 64){
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString("privateKey",pvt.text);
                          prefs.setBool("loggedIn", true);
                          Navigator.pushNamedAndRemoveUntil(context,'/home',(r)=> false);
                        }
                        else{Toast.show("Invalid private key",context);}
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("You need to enter private key first", style: TextStyle(color:Colors.red),)
                  ],
                ),
              )
          ),
        ),
      ),

    );
  }

}