import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:async/async.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _enterDataField = TextEditingController();
  String storedData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Persistant Storage"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: _enterDataField,
              decoration: InputDecoration(labelText: "Enter Data to be Saved"),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                writeData(_enterDataField.text);
              },
              child: Text("Save Data"),
              padding: EdgeInsets.all(8.0),
              color: Colors.deepPurple,
              textColor: Colors.white,
            ),
          ),
          RaisedButton(
            onPressed: () {
              readData(); //doesnt update text field on button press
            },
            child: Text("Retrieve Data"),
          ),
          Center(
            child: Text("$storedData")
//    Below Method will not update on button press since read data will keep on runing and data will keep on updating
//          My requirement was to show stored data on button presss
//          It is achieved by calling a function on button press
//          In a Future function a variable will be updated using setState() and the value will be Changed
//          ****Always use setState if a variable will get a value later on***
//            child: FutureBuilder(
//              future: readData(),
//              builder: (BuildContext context, AsyncSnapshot snapshot) {
//                if (snapshot.hasData != null) {
//                  return Text("Retrieved data: ${snapshot.data}");
//                } else {
//                  return Text("No saved data exist");
//                }
//              },
//            ),
          )
        ],
      ),
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> writeData(String message) async {
    final file = await _localFile;

    print("stored $message");
    return file.writeAsString('$message');
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;
      String data = await file.readAsString();
      setState(() { //this will be executed when state of object will change i.e data will have some data stored in it
        storedData = data;
      });
      return data;
    } catch (e) {
      return "Nothing saved";
    }
  }
}
