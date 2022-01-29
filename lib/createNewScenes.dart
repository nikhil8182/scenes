import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class createNewScenes extends StatefulWidget {
  const createNewScenes({Key? key}) : super(key: key);

  @override
  _createNewScenesState createState() => _createNewScenesState();
}

final myController = TextEditingController();
final databaseReference = FirebaseDatabase.instance.reference();

class _createNewScenesState extends State<createNewScenes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController.addListener;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('scenes')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Text(
            "Create New Scenes",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
          Text('scene naem = ${myController.text}'),
          const MyCustomForm(),
          ListViewBuilder(),

        ],
      ),
    );
  }

  getData() {
    databaseReference.once().then((DataSnapshot snapshot) {
      // print('Data : ${snapshot.value}');
      dynamic data = snapshot.value;
      return data;
    });
  }
}


List x = ['a','b','c','nikhil','prem'];

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: myController,
            onChanged: (text) {
              print('First text field: $text');
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter scene name',
            ),
          ),
        ),
      ],
    );
  }
}
class ListViewBuilder extends StatefulWidget {
  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {

  bool wifiNotifier = false;
  String ip = " ";
  String username = " ";
  bool notifier = false;
  bool mobNotifier = false;
  bool currentIndex = false;
  bool valueStatus = false;
  List <String> selectedDeviceStateTrueList = [];

  List name = [];
  List pg = [];
  List data = [];
  bool first = false;
  bool status = false;
  int statusInt = 0;
  List toggleValues = [];
   int selectedIndex =0;
   List selectedDevices = [];
   List selectedDevicesStatus = [];
   List<String> localDataVal = [];
   List<String> dumVariable = [];
   List<String> valueVariable = [];
   List<String> valueStatusList = [];
   var dataJson;
   var acount = 0;
   var count = 0;
   late SharedPreferences loginData;
   String userName = " ";
   String ipAddress = "192.168.1.18:80";
   String ipLocal = " ";
   String onlineIp = " ";
   String phoneNumber = " ";
   String email = " ";
   bool noLocalServer = false;
   var localServer;
   bool bothOffOn = false ;
   var smartHome;
   int intValue = 0;



   keyValues() async {

     loginData = await SharedPreferences.getInstance();
     // final locIp = loginData.getString('ip') ?? null;
     // final onIp = loginData.getString('onlineIp') ?? null;
     final locIp = ipAddress;
     final onIp = ipAddress;

     if((locIp != null)&&(locIp != "false")){
       print("locIp $locIp ");
       final response = await http.get(Uri.parse("http://$locIp/")).timeout(
           const Duration(milliseconds: 1000),onTimeout: (){
         //ignore:avoid_print
         //print(" inside the timeout gridPage ");
         setState(() {
           ipAddress = onIp;
         });
         data.clear();
         initial();
         throw '';
       });
       if(response.statusCode > 0){
         //setState is used timer verify in grid page **************************
         setState(() {
           //ignore:avoid_print
           //print("im inside the if $ipLocal local ip in gridPage");
           data.clear();
           ipAddress = locIp;
           initial();
           //ignore:avoid_print
           //print("im inside the if and the ipAddress is $ipAddress  gridPage");
         });
       }

       //localDataVariableStorage();
     }else if(locIp == "false"){
       setState(() {
         ipAddress = locIp;
         initial();
       });
     }

   }



   Future<void> initial() async {
     //loginData = await SharedPreferences.getInstance();
     //username = loginData.getString('username')!;

     if (ipAddress == null) {
       //fireData();
     } else if ((data == null) || (data.length == 0)) {

       if (ipAddress.toString() != 'false') {

         final response = await http.get(Uri.parse("http://$ipAddress/",));
         var fetchdata = jsonDecode(response.body);

         setState(() {
           localDataVal.clear();
           dumVariable.clear();
           var dumData = fetchdata;
           for (int i = 0; i < dumData.length; i++)
           {
             dumVariable.add(dumData[i]["Room"].toString());
             valueVariable.add(dumData[i]["Device_Name"].toString());
             valueStatusList.add(dumData[i]["Device_Status"].toString());
           }
           localDataVal = dumVariable.toSet().toList();
           data = localDataVal;
           loginData.setStringList('dataValues', localDataVal);
           initial();
         });
       }else if((ipAddress.toString() == 'false'))
       {
         print("im inside the false");
         setState(() {
           getName();

           // fireData();
           // localDataVal.clear();
           // //print(dataJson.keys.toList());
           // data = dataJson.keys.toList();
           // for(int i =0; i<data.length ; i++)
           // {
           //   localDataVal.add(data[i].toString());
           // }
           // //print("im local in else if loop data $localDataVal");
           // loginData.setStringList('dataValues', localDataVal);
         });
         //showAnotherAlertDialog(context);
       }
     } else {
       //print("im going into the getName of list in initial ");
       getName();
     }
   }

   checkData() async {
     //print("im inside the check data of first page");
     loginData = await SharedPreferences.getInstance();
     if(ipLocal == "false"){
       loginData.setString('username', userName);
       loginData.setString('ip', ipLocal );
       loginData.setString('onlineIp', onlineIp);
       keyValues();
     }else{
       loginData.setString('ip', ipLocal );
       loginData.setString('onlineIp', onlineIp);
       loginData.setString('username', userName);
       keyValues();
     }
   }

   Future<void> toggleButton(int index, int sts) async {
     setState(() {
       intValue = 0;
     });
     toggleValues.clear();
     for (int i = 0; i < data.length; i++) {
       if (data[i].toString().contains(name[index].toString())) {
         toggleValues.add(data[i].toString());
       }
     }
     for (int i = 0; i < toggleValues.length; i++) {
       print(toggleValues[i]);
       while (intValue < 2) {
         // print(toggleValues[i]);
         // print("$ipAddress =======");
         // ip = loginData.getString('ip');
         await http.get(Uri.parse('http://$ipAddress/${toggleValues[i]}/$sts'));
         intValue++;
         print(intValue);
       }
       setState(() {
         intValue = 0;
       });
     }
   }

   Future getName() async {
     //  print("im inside the getname of list funtion");
     // print("data is 8888888888888888888888888888888888 $data");
     for (int i = 0; i < data.length; i++) {
       if (data[i].toString().contains("Admin Room") &&
           (!name.contains(data[i].toString().contains("Admin Room")))) {
         name.add("Admin Room");
         pg.add("Admin Room");
       } else if (data[i].toString().contains("Hall") &&
           (!name.contains(data[i].toString().contains("Hall")))) {
         name.add("Hall");
         pg.add("Hall");
       } else if (data[i].toString().contains("Living Room") &&
           (!name.contains(data[i].toString().contains("Living Room")))) {
         name.add("Living Room");
         pg.add("Living Room");
       } else if (data[i].toString().contains("Garage") &&
           (!name.contains(data[i].toString().contains("Garage")))) {
         name.add("Garage");
         pg.add("Garage");
       } else if (data[i].toString().contains("Kitchen") &&
           (!name.contains(data[i].toString().contains("Kitchen")))) {
         name.add("Kitchen");
         pg.add("Kitchen");
       } else if (data[i].toString().contains("Bathroom1") &&
           (!name.contains(data[i].toString().contains("Bathroom1")))) {
         name.add("Bathroom1");
         pg.add("Bathroom1");
       }  else if (data[i].toString().contains("Bathroom2") &&
           (!name.contains(data[i].toString().contains("Bathroom2")))) {
         name.add("Bathroom2");
         pg.add("Bathroom2");
       } else if (data[i].toString().contains("Bathroom") &&
           (!name.contains(data[i].toString().contains("Bathroom")))) {
         name.add("Bathroom");
         pg.add("Bathroom");
       }else if (data[i].toString().contains("Master Bedroom") &&
           (!name.contains(data[i].toString().contains("Master Bedroom")))) {
         name.add("Master Bedroom");
         pg.add("Master Bedroom");
       } else if (data[i].toString().contains("Bedroom1") &&
           !name.contains(data[i].toString().contains("Bedroom1"))) {
         name.add("Bedroom1");
         //print("----- bedroom1 $name name -------");
         pg.add("Bedroom1");
         //print("----- bedroom1 $pg pg -------");
       } else if (data[i].toString().contains("Bedroom2") &&
           (!name.contains(data[i].toString().contains("Bedroom2")))) {
         name.add("Bedroom2");
         //print("----- bedroom1 $name name -------");
         pg.add("Bedroom2");
         //print("----- bedroom1 $pg pg -------");
       } else if (data[i].toString().contains("Bedroom") &&
           (!name.contains(data[i].toString().contains("Bedroom")))) {
         name.add("Bedroom");
         pg.add("Bedroom");
       } else if (data[i].toString().contains("Store Room") &&
           (!name.contains(data[i].toString().contains("Store Room")))) {
         name.add("Store Room");
         pg.add("Store Room");
       } else if (data[i].toString().contains("Outside") &&
           (!name.contains(data[i].toString().contains("Outside")))) {
         name.add("Outside");
         pg.add("Outside");
       } else if (data[i].toString().contains("Parking") &&
           (!name.contains(data[i].toString().contains("Parking")))) {
         name.add("Parking");
         pg.add("Parking");
       }else if (data[i].toString().contains("Garden") &&
           (!name.contains(data[i].toString().contains("Garden")))) {
         name.add("Garden");
         pg.add("Garden");
       }else if (data[i].toString().contains("Farm") &&
           (!name.contains(data[i].toString().contains("Farm")))) {
         name.add("Farm");
         pg.add("Farm");
       }
     }

     // name = name.toSet().toList();
     // pg = pg.toSet().toList();

     setState(() {
       name = name.toSet().toList();
       pg = pg.toSet().toList();
       //print("$name  88889978");
     });
     // print("name $name");
     // print("pg $pg");

     //return "success";
   }

   @override
  void initState() {
     keyValues();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("ListView.builder")
      ),
      body: ListView.builder(

          itemCount: valueVariable.length,
          itemBuilder: (BuildContext context,int index){
            return Card(
              child: ListTile(


              tileColor: selectedDevices.isNotEmpty?selectedDevices.contains(valueVariable[index])?Colors.green:Colors.white:Colors.white,
                onTap: (){
                  initial();
                  // print(data);
                  // print(name);
                  // print(valueVariable);
                  print("valueStatusList== $valueStatusList");

                  setState(() {
                    if(true){
                      print(index);
                      // print(selectedDevices[index]);
                      print('inside  the if');
                      print('inside  the if selectedDevices.length ${selectedDevices.length}');
                      for(int i = 0; i <= selectedDevices.length ; i++){
                        print("im inside the for  ");
                        print(selectedDevices);
                        print(index);
                        if(selectedDevices.contains(valueVariable[index]))
                        {
                          print("im inside the if else ");
                          selectedDevices.remove(valueVariable[index]);
                          selectedDevicesStatus.remove(valueStatusList[index]);

                          break;
                        }else if(selectedDevices.isEmpty){
                          print('im inside the else if - condition ');
                          selectedDevices.add(valueVariable[index]);
                          selectedDevicesStatus.add(valueStatusList[index]);
                          break;
                        }else{
                          print("im inside the else ");
                          selectedDevices.add(valueVariable[index]);
                          selectedDevicesStatus.add(valueStatusList[index]);

                          break;
                        }
                      }
                    }
                    //selectedDevices.add(index);
                    selectedIndex = index;
                    //selectedDevices.add(index);

                    print('index = ${index}');
                    print('selected index = $selectedIndex');
                    print("list of selected device index = $selectedDevices");
                    print("list of selected device index = $selectedDevicesStatus");

                  });



                },
                  trailing:
                  selectedDevices.contains(valueVariable[index])?
                  Switch(onChanged: (bool value) {
                    setState(() {
                      print('trail= $index');
                      if (value){
                        selectedDeviceStateTrueList.add(valueVariable[index]);
                      }
                      else{
                        selectedDeviceStateTrueList.remove(valueVariable[index]);
                      }


                    });


                  }, value: selectedDeviceStateTrueList.contains(valueVariable[index])?true:false,):null,
                  title:Text("${valueVariable[index]}")
              ),
            );
          }
      ),
    );
  }
}
// if(selectedDevices.length>=index){
// print('inside  the if');
// print('inside  the if selectedDevices.length ${selectedDevices.length}');
// for(int i = 0; i <= selectedDevices.length ; i++){
// print("im inside the for  ");
// print(selectedDevices);
// print(index);
// if(selectedDevices.contains(valueVariable[index]))
// {
// print("im inside the if else ");
// selectedDevices.removeAt(index);
// break;
// }else if(selectedDevices.isEmpty){
// print('im inside the else if - condition ');
// selectedDevices.add(valueVariable[index]);
// break;
// }else{
// print("im inside the else ");
// selectedDevices.add(valueVariable[index]);
// break;
// }
// }
// }
// (selectedDevices.isNotEmpty)?(selectedDevices.length>index)?selectedDevices[index]==valueVariable[index]?Colors.green:Colors.white:Colors.white:Colors.white,