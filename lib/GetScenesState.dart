import 'package:flutter/material.dart';
import 'package:scenes/checkBeforeAdding.dart';
import 'package:scenes/createNewScenes.dart';


class GetScenesState extends StatefulWidget {
  List value;

   GetScenesState({Key? key,required this.value}) : super(key: key);

  @override
  _GetScenesStateState createState() => _GetScenesStateState();
}

class _GetScenesStateState extends State<GetScenesState> {
  var ids;
  List trueDevicesList = [];



  @override
  Widget build(BuildContext context) {
    // var ids
    return Scaffold(

      appBar: AppBar(title: Text("set selected device state"),
      actions: [
        IconButton(onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>   cba(trueDevices: trueDevicesList,selectedDevice:( widget.value),)),
          );

        }, icon: Icon(Icons.skip_next_rounded))
      ],

      ),
      body: ListView.builder(
          itemCount: (widget.value).length ,
          itemBuilder: (BuildContext context,int index){
            return ListTile(

                trailing: Switch(onChanged: (bool value){
                  setState(() {
                    print(trueDevicesList.contains(widget.value[index]));

                    if(trueDevicesList.contains(widget.value[index])==false){
                      print(":inside the add if");
                    trueDevicesList.add(widget.value[index]);
                    print("devices which are true = $trueDevicesList");}
                    else{
                      trueDevicesList.remove(widget.value[index]);
                    }


                  });

                }, value: trueDevicesList.contains(widget.value[index])?true:false),
                title:Text("${widget.value[index]}")
            );
          }
      ),
    );
  }
}
