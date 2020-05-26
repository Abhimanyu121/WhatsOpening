import 'package:flu/Constants.dart';
import 'package:flu/Models/POIModel.dart';
import 'package:flu/Models/TimeModel.dart';
import 'package:flu/Wrappers/MaticWrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
class TimeList extends StatefulWidget {
  @override
  _TimeListState createState() => _TimeListState();
}

class _TimeListState extends State<TimeList> {
  var colorArr = [Colors.blue,Colors.redAccent,Colors.green, Colors.deepOrange];
  bool loading  =false;
  List<TimeModel> timings;
  POIModel args;
  refetch(hash){
    timings = null;
    MaticWrapper.fetchList(hash).then((ls)async{
      var arr =await  MaticWrapper.getAddress(hash);
      List<TimeModel> modelList = List<TimeModel>();
      for(int i=0; i<ls[0].length;i++){
        TimeModel model = new TimeModel(
            opening_hour: ls[0][i],
            opening_min : ls[1][i],
            closing_hour:  ls[2][i],
            closing_min: ls[3][i],
            upvotes:  ls[4][i],
            downvotes: ls[5][i],
            address: arr[0][i].toString(),
            hash: hash

        );
        modelList.add(model);

      }

      setState((){
        timings = modelList;

      });
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero,() {
      args = ModalRoute.of(context).settings.arguments;
      refetch(args.listingHash);

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
              "Timings",
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
                  "List",
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
      body: timings==null?Center(child: SpinKitFadingCircle(size:50, color:Colors.blue),):timings.length==0?Center(
        child: Text("No timings available"),
      ):ListView.builder(
          itemCount: timings.length,
          itemBuilder:(BuildContext context, int index){

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: _circle(context, index),
                title: Text("Opening Time: ${timings[index].opening_hour}:${timings[index].opening_min}\nClosing Time: ${timings[index].closing_hour}:${timings[index].closing_min}"),
                subtitle: Text("Upvotes: ${timings[index].upvotes}  Downvotes: ${timings[index].downvotes}"),
                trailing: SizedBox(
                  width: MediaQuery.of(context).size.width*0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.thumb_up, color: Colors.green,size: 25,),
                        onPressed: (){
                          MaticWrapper.upvote(timings[index].address, timings[index].hash).then((val){
                            refetch(args.listingHash);
                          });
                          Toast.show("Upvoting", context);

                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.thumb_down, color: Colors.red,size: 25,),
                        onPressed: (){
                          print(index);
                          MaticWrapper.downvote(timings[index].address, timings[index].hash).then((val){
                            refetch(args.listingHash);
                          });
                          Toast.show("Downvoting", context);

                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }
      )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  _circle(BuildContext ctx, int index){
    return Container(
      width: MediaQuery.of(ctx).size.width *0.12,
      height: 100,
      child: Center(
        child: Text(index.toString()),
      ),
      decoration: BoxDecoration(
          color: colorArr[index%4] ,
          shape: BoxShape.circle
      ),
    );
  }
}
