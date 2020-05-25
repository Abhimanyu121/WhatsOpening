import 'package:flu/Constants.dart';
import 'package:flu/Models/POIModel.dart';
import 'package:flu/Wrappers/MaticWrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class TimePicker extends StatefulWidget {
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {

  TimeOfDay _starttime=TimeOfDay.now();
  TimeOfDay _endtime=TimeOfDay.now();
  bool end= false;
  bool start =false;
  POIModel args;
  bool loading  =false;
  @override
  void initState() {
    Future.delayed(Duration.zero,() {
      args = ModalRoute.of(context).settings.arguments;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: nearlyWhite,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: nearlyWhite,
        title: Row(
          children: <Widget>[
            Text(
              "Time",
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Row(children: <Widget>[
              Text(
                "  ",
              ),
            ]),
            Row(
              children: <Widget>[
                Text(
                  "Picker",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 26.0,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: loading?Center(child: SpinKitFadingCircle(size:50, color:Colors.blue)):Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Please Select Opening and Closing Time", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                title: Text('Opening Time: ${_starttime.hour}:${_starttime.minute}'),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: starting_time,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                title: Text('Closing Time: ${_endtime.hour}:${_endtime.minute}'),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: ending_time,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  child: Text("Submit"),
                  borderSide: BorderSide(color: Colors.black87),
                  onPressed: ()async {
                    setState(() {
                      loading =true;
                    });
                    bool status = await MaticWrapper.addTime(_starttime.minute,_starttime.hour,_endtime.minute,  _endtime.hour,args.listingHash);
                    Navigator.pop(context);
                  },

                ),
              ],
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  starting_time() async{
    TimeOfDay selectedTime=await showTimePicker(context: context, initialTime: _starttime,);
    if(selectedTime!=null)
      setState(() {
        start =true;
        _starttime=selectedTime;
      });
  }
  ending_time() async{
    TimeOfDay selectTime=await showTimePicker(context: context, initialTime: _endtime);
    if(selectTime!=null)
      setState(() {
        end =true;
        _endtime=selectTime;
      });
  }
}
