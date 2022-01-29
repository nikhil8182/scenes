import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scenes/createNewScenes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MaterialApp(home: ListViewBuilder(),));
}
FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();
class Nik extends StatefulWidget {
  const Nik({Key? key}) : super(key: key);

  @override
  _NikState createState() => _NikState();
}

class _NikState extends State<Nik> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('scenes'),actions: [IconButton(onPressed: (){
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
          MaterialPageRoute(builder: (context) =>  ListViewBuilder()),
        );
      }, icon: Icon( Icons.add))],),
      body: Column(
    children: [
      Center(child: Text("Scenes Page",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),

    ],
    )
    
    );
  }
}
