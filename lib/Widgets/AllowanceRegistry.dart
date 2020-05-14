import 'package:flutter/material.dart';
import 'package:flu/Wrappers/EthWrapper.dart';
import 'package:toast/toast.dart';

class RegistryAllow extends StatefulWidget {
  @override
  RegistryState createState() => RegistryState();
}

class RegistryState extends State<RegistryAllow> {
  @override
  Widget build(BuildContext context) {
    var amount = new TextEditingController();
    TextStyle style = TextStyle(
        fontFamily: 'Montserrat', fontSize: 15.0, color: Colors.white);
    TextStyle hintStyle = TextStyle(
        fontFamily: 'Montserrat', fontSize: 15.0, color: Colors.white70);

    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 7.0),
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Set new allowance value for Registry",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: amount,
                autovalidate: true,
                validator: (val) => val == ""
                    ? null
                    : (double.parse(val) <= 0 ? "Invalid amount" : null),
                obscureText: false,
                style: style,
                decoration: InputDecoration(
                    fillColor: Colors.black87,
                    filled: true,
                    hoverColor: Colors.blue,
                    focusColor: Colors.blue,
                    hintStyle: hintStyle,
                    contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    hintText: "FOAM tokens to approve",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: new BorderSide(
                          color: Colors.blue,
                        ))),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 28.0, 10.0, 15.0),
              child: RaisedButton(
                splashColor: Colors.white10,
                shape: Border.all(width: 1.0, color: Colors.green),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  EthWrapper wrapper = new EthWrapper();
                  Toast.show("Please Wait", context);
                  var resp =
                      await wrapper.approveReg(double.parse(amount.text));
                  Toast.show(resp, context);
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                color: Colors.white,
                child: Text('Transact',
                    style: TextStyle(
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      fontSize: 15.0,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
