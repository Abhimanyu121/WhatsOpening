import 'package:flutter/material.dart';
import 'package:flu/Wrappers/EthWrapper.dart';
import 'package:toast/toast.dart';

class VoteAllowance extends StatefulWidget {
  @override
  VoteState createState() => VoteState();
}

class VoteState extends State<VoteAllowance> {
  @override
  Widget build(BuildContext context) {
    var amount = new TextEditingController();
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
    // TODO: implement build
    return Container(
      height: 350,
      width: 350,
      color: Colors.black,
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            )),
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(30),
                      child: Text(
                        "Set new allowance value for Voting Contract",
                        style: TextStyle(
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
                          contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          hintText: "FOAM tokens to approve",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
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
                        var resp = await wrapper
                            .approveVote(double.parse(amount.text));
                        Toast.show(resp, context);
                        Navigator.of(context).pop();
                      },
                      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      color: Colors.black,
                      child: Text('Transact',
                          style:
                              TextStyle(color: Colors.white, fontSize: 15.0)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
