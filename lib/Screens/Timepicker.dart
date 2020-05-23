import 'package:flutter/material.dart';
class TimePicker extends StatefulWidget {
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {

  TimeOfDay _starttime=TimeOfDay.now();
  TimeOfDay _endtime=TimeOfDay.now();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: Column(

        children: <Widget>[
          ListTile(
            title: Text('Starting time:${_starttime}'),
            trailing: Icon(Icons.keyboard_arrow_down),
            onTap: starting_time,
          ),
          ListTile(
            title: Text('Ending time:${_endtime}'),
            trailing: Icon(Icons.keyboard_arrow_down),
            onTap: ending_time,
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  starting_time() async{
    TimeOfDay selectedTime=await showTimePicker(context: context, initialTime: _starttime,);
    if(selectedTime!=null)
      setState(() {
        _starttime=selectedTime;
      });
  }
  ending_time() async{
    TimeOfDay selectTime=await showTimePicker(context: context, initialTime: _endtime);
    if(selectTime!=null)
      setState(() {
        _endtime=selectTime;
      });
  }
}
