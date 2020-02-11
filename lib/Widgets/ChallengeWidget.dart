import 'package:flu/Wrappers/EthWrapper.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flu/ThemeData.dart';
class ChallengeWidget extends StatefulWidget{
  @override
  ChallengeWidgetState createState() => new ChallengeWidgetState();
}
class ChallengeWidgetState extends State<ChallengeWidget>{
  TextEditingController amount = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppTheme.nearlyDarkBlue,
          HexColor("#6F56E8")
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
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(50),
            )
        ),
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(20),
                child: Text("Amount to Stake", style: TextStyle(fontWeight: FontWeight.bold),)
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: amount,
                autovalidate: true,
                validator: (val) => val==""?null:(double.parse(val)<=100?
                "Invalid amount":
                null),
                obscureText: false,
                style: style,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15,10,15,10),
                    hintText: "FOAM tokens to approve",
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: ()async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  EthWrapper wrapper = new EthWrapper();
                  Toast.show("Please Wait", context);
                  var resp = await wrapper.approveReg(double.parse(amount.text));
                  Toast.show(resp, context);
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.all(12),
                color: Colors.blueAccent,
                child: Text('Stake', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

}