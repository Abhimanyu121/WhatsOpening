import 'package:flu/Models/ArgListPanelChallege.dart';
import 'package:flu/Models/TimeModel.dart';
import 'package:flu/Wrappers/MaticWrapper.dart';
import 'package:flutter/material.dart';
import 'package:flu/Models/POIModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'Map.dart';
class PanelUi extends StatefulWidget{
  Function fetchTimings;
  POIModel model;
  Function refresh;
  GlobalKey<MapState> _MapState;
  PanelUi(POIModel model, Key key, Function refresh){
    this.model = model;
    this._MapState = key;
    this.refresh = refresh;
  }
  @override
  PanelState createState() =>PanelState() ;
}
class PanelState extends State<PanelUi>{
  BuildContext context;
  List<TimeModel> timings;
  List<TimeModel> sorted;
  var model;
  var colorArr = [Colors.blue,Colors.redAccent,Colors.green, Colors.deepOrange];
  bool state =false;
  @override
  void initState() {
    print("widget.model.listingHash");
    MaticWrapper.fetchList(widget.model.listingHash).then((ls)async{
      var arr =await  MaticWrapper.getAddress(widget.model.listingHash);
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
          hash: widget.model.listingHash
        );
        modelList.add(model);
      }
      sorted = modelList;
      sorted.sort(mySortComparison);
      setState((){
        timings = modelList;
      });
    });
    widget.fetchTimings = refetch;
    super.initState();
  }
  refetch(){
    timings = null;
    MaticWrapper.fetchList(widget.model.listingHash).then((ls)async{
      var arr =await  MaticWrapper.getAddress(widget.model.listingHash);
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
            hash: widget.model.listingHash
        );
        modelList.add(model);
      }
      sorted = modelList;
      sorted.sort(mySortComparison);
      setState((){
        timings = modelList;
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    print(widget.model.listingHash);
    try{
      if(model.listingHash!=widget.model.listingHash){
        refetch();
        model = widget.model;
      }
    }catch(e){
      refetch();
      model = widget.model;
    }

    // TODO: implement build
    print("check state");
    print(widget.model.state);
    return Container(
      child: Column(

        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),

          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
            child: Text(
              widget.model.name,
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
            ),
          ),

          Center(
            child: SizedBox(
              height: 70,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount   : widget.model.tags.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: ((BuildContext context, int index){
                  return SizedBox(
                    height: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 10,
                        child: Card(

                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          color: colorArr[index%4],
                          child: SizedBox(
                              width:100,
                              child: Center(child: Text(widget.model.tags[index],textAlign: TextAlign.center,))),
                        ),
                      ),
                    ),
                  );
                }) ,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.45,
            child: ListView(
              cacheExtent: 100,
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
                  child: Text(
                    "Owner:",
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
                  child: Text(
                    "${widget.model.owner}",
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
                  child: Text(
                    "Listing Hash:",
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
                  child: Text(
                    "${widget.model.listingHash}",
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                timings==null?SpinKitFadingCircle(size:50, color:Colors.blue):timings.length==0?Container():Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
                      child: Text(
                        "Most Recent Timings:",
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                      ),
                    ),
                    ListTile(
                      isThreeLine: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Opening Time: ${timings[timings.length-1].opening_hour}:${timings[timings.length-1].opening_min}",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
                          ),
                          Text("Closing Time: ${timings[timings.length-1].closing_hour}:${timings[timings.length-1].closing_min}",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
                          )
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.thumb_up, color: Colors.green,),
                                onPressed:() async{
                                  MaticWrapper.upvote(timings[timings.length-1].address, timings[timings.length-1].hash).then((tx){
                                    refetch();
                                  });
                                  Toast.show("Upvoting", context);
                                } ,
                              ),
                              Text(timings[timings.length-1].upvotes.toString()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.thumb_down, color: Colors.red,),
                                onPressed:() async{
                                  MaticWrapper.downvote(timings[timings.length-1].address, timings[timings.length-1].hash).then((tx){
                                    refetch();
                                  });
                                  Toast.show("downvoting", context);
                                } ,
                              ),
                              Text(timings[timings.length-1].downvotes.toString())
                            ],
                          )


                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
                      child: Text(
                        "Most Upvoted Timings:",
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                      ),
                    ),
                    ListTile(
                      isThreeLine: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Opening Time: ${sorted[0].opening_hour}:${sorted[0].opening_min}",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
                          ),
                          Text("Closing Time: ${sorted[0].closing_hour}:${sorted[0].closing_min}",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.thumb_up, color: Colors.green,),
                                onPressed:() async{
                                  MaticWrapper.upvote(sorted[0].address, sorted[0].hash).then((tx){
                                    refetch();
                                  });
                                  Toast.show("Upvoting", context);
                                } ,
                              ),
                              Text(sorted[0].upvotes.toString()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.thumb_down, color: Colors.red,),
                                onPressed:() async{
                                  MaticWrapper.downvote(sorted[0].address, sorted[0].hash).then((tx){
                                    refetch();
                                  });
                                  Toast.show("Downvoting", context);
                                } ,
                              ),
                              Text(sorted[0].downvotes.toString())
                            ],
                          )

                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
                  child: Text(
                    "Status:",
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0,10.0,8,8),
                  child: Text(
                    "${widget.model.state}",
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: widget.model.state=="applied"?OutlineButton(
                        borderSide: BorderSide(
                            color: Colors.black87
                        ),
                        child: Text("Challenge the Place",style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),), onPressed: ()async {
                        ArgListPanelChallenge args= new ArgListPanelChallenge();
                        args.model= widget.model;
                        args.key = widget._MapState;
                        widget.refresh();
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        var pvt = prefs.getString("privateKey");
                        if(pvt!=null){
                          Navigator.pushNamed(
                            context,
                            '/ChallengeScreen',
                            arguments: args,
                          );
                        }
                        else{
                          Navigator.pushNamed(context, '/LoginWithoutSkip');
                        }
                      },):Container(),
                    ),
                    Center(child: OutlineButton(
                      borderSide: BorderSide(
                          color: Colors.black87
                      ),
                      child: Text(
                        'Add Timings',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),),
                      onPressed:() async{
                        Navigator.pushNamed(
                          context,
                          '/Timepicker',
                          arguments: widget.model
                        );
                      } ,
                    ),),
                  ],
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
  int mySortComparison(TimeModel a, TimeModel b) {
    final propertyA = a.upvotes -a.downvotes;
    final propertyB =b.upvotes-b.downvotes;
    if (propertyA < propertyB) {
      return 1;
    } else if (propertyA > propertyB) {
      return -1;
    } else {
      return 0;
    }
  }
}