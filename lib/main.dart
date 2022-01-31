import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scenes/createNewScenes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Nik(),
  ));
}

FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();

class Nik extends StatefulWidget {
  const Nik({Key? key}) : super(key: key);

  @override
  _NikState createState() => _NikState();
}

class _NikState extends State<Nik> {
  var scenesData;
  List scenesName = [];
  List scenesDatas = [];

  getData() async {
    await databaseReference.once().then((value) {
      scenesName.clear();
      setState(() {
        scenesData = value.value;
        //print(scenesData);

//   print(scenesData['SmartHome']['scenes']);
//   var key  = value.key;
//
//   print("key = $key");
//
//   var z = scenesData['SmartHome']['scenes'];
//   List data = [];
//   // print(scenesData.runtimeType);
//   print("inside for ${z.length}");
//
// for (int a = 0; a<=z.length;a++){
//   // print("inside for ${z.length}");
//   // print(z);
//
// }
//   //print(z);
      });

      Map<dynamic, dynamic> values = value.value['SmartHome']['scenes'];
      values.forEach((key, values) {
        // print("values  the ${values} ");
        scenesName.add(values);
      });
      Map<dynamic, dynamic> _values = value.value['SmartHome']['scenes'];
      values.forEach((key, values) {
        // print("values  the ${values} ");
        scenesDatas.add(values);
      });

// print(" needs ${needs[0]} ");
// for(int i =0;i<scenesName.length;i++){
//
//   print("needs ${scenesName[i]['sceneName']}");
//   print("  ----------------------------------------------------------------------");
//
// }
//
//
    });
  }

  // shortAList(List l ){
  //   print("inside short function ");
  //   var ten = l.sort();
  //   print(l.sort((a, b) => a.compareTo(b)));
  //    return 5;
  //
  //
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    return Scaffold(
        appBar: AppBar(
          title: const Text('scenes'),
          actions: [
            IconButton(
                onPressed: () {
                  print("object db");
                  // var da ={
                  //   'sceneName':'gm',
                  //   'sceneList':{
                  //     'room1':{
                  //       '1': {
                  //       'deviceName':'bulb',
                  //       'state':'on' },
                  //        '2':{
                  //
                  //       'deviceName':'tube light',
                  //       'state':'on'
                  //
                  //     },
                  //   }
                  // }};
                  // databaseReference.child('SmartHome').child('scenes').push().set(da);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListViewBuilder()),
                  );
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: ListView.builder(
            itemCount: scenesName.length, //scenesData.length??
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  onLongPress: (){print("deleting ${scenesDatas[index]['sceneName']}");},
                    onTap: () async {

                      print("_________________________________________________________________________________________________");



                      var trueData= scenesDatas[index]['trueDevices'];
                      var idsData= scenesDatas[index]['ids'];
                      List<int> trueDataList=[];
                      List<int> idsDataList= [];



                      if(trueData != null){
                      for (var td in trueData){
                        trueDataList.add(int.parse(td));

                      }}


                      for (var id in idsData){
                        idsDataList.add(int.parse(id));

                      }



                      List <int> falseDataList = [];

                      for (int x in idsDataList){

                        if(trueDataList.isNotEmpty){

                        if(trueDataList.contains(x)){
                          null;
                        }else{

                          falseDataList.add(x);

                        }
                      }else{

                          falseDataList.add(x);

                        }

                      }
                      print("true datas = $trueData");
                      print("false datas = $falseDataList");

                      if(trueData!=null){
                        for (var d in trueData) {
                          print("$d is true");
                          var fff = (await http.put(Uri.parse('http://192.168.1.18/$d/'),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(
                                        <String, bool>{"Device_Status": true}),
                                  ));
                        }
                      }

                      if(falseDataList!=null){
                        for (var d in falseDataList) {
                          print("$d is false");
                          var fff = (await http.put(Uri.parse('http://192.168.1.18/$d/'),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(
                                <String, bool>{"Device_Status": false}),
                          ));

                        }
                      }



                    },
                    title: Text(" ${scenesName[index]['sceneName']}")),
              );
            })

        // body: Center(
        //   child:
        //   ElevatedButton(
        //     onPressed: () {
        //     setState(()
        //     {
        //         getData();
        //     });
        //
        //   },
        //   child: Text("press "),
        //
        //
        // ),),

        );
  }
}
