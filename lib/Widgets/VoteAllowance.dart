import 'package:flutter/material.dart';
import 'package:flu/Wrappers/EthWrapper.dart';
import 'package:toast/toast.dart';

import '../HexColor.dart';

class VoteAllowance extends StatefulWidget {
  @override
  VoteState createState() => VoteState();
}

class VoteState extends State<VoteAllowance> {
  @override
  Widget build(BuildContext context) {
    var amount = new TextEditingController();
    TextStyle style = TextStyle(
        fontFamily: 'Montserrat', fontSize: 15.0, color: Colors.white);
    TextStyle hintStyle = TextStyle(
        fontFamily: 'Montserrat', fontSize: 15.0, color: Colors.white70);
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
      height: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          HexColor("#00264d"),
          HexColor("#003366"),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(
                      "Set new allowance value for Voting Contract",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: amount,
                    autovalidate: true,
                    validator: (val) => val == ""
                        ? null
                        : (double.parse(val) <= 0 ? "Invalid amount" : null),
                    obscureText: false,
                    style: style,
                    decoration: InputDecoration(
                        fillColor: Colors.black,
                        filled: true,
                        hintStyle: hintStyle,
                        contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        hintText: "FOAM tokens to approve",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: new BorderSide(color: Colors.green))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 28.0, 10.0, 50.0),
                  child: RaisedButton(
                    splashColor: Colors.black,
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      EthWrapper wrapper = new EthWrapper();
                      Toast.show("Please Wait", context);
                      var resp =
                          await wrapper.approveVote(double.parse(amount.text));
                      Toast.show(resp, context);
                      Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                    color: Colors.white,
                    child: Text('Transact',
                        style: TextStyle(color: Colors.black, fontSize: 15.0)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
