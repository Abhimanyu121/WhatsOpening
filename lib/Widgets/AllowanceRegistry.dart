import 'package:flutter/material.dart';
import 'package:flu/Wrappers/EthWrapper.dart';
class RegistryAllow extends StatefulWidget{
  @override
  RegistryState createState() => RegistryState();
}
class RegistryState extends State<RegistryAllow>{
  @override
  Widget build(BuildContext context) {
    var amount = new TextEditingController();
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
    // TODO: implement build
    return Card(
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
            child: Text("Set new allowance value for Registry", style: TextStyle(fontWeight: FontWeight.bold),)
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: amount,
              autovalidate: true,
              validator: (val) => val==""?null:(double.parse(val)<=0?
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

              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('Transact', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

}