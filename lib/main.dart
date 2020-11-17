import 'dart:collection';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutterpilot/listItems/cameraAlarm.dart';

import 'package:flutterpilot/listItems/cameraArmed.dart';
import 'package:flutterpilot/photos.dart';
import 'package:flutterpilot/photos_downloader.dart';
import 'package:flutterpilot/show_image.dart';

import 'firebase.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> _showList = List();
  List<Widget> _mainList = List();
  List<Widget> _cameraList = List();

  FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    firebaseMesagingConfig();
    super.initState();

    initLists();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/photos': (context) => Photos(),
        '/photos_downloader': (context) => PhotoDownloader(),
        '/show_image': (context) => ShowImage(),
      },
      home: Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 35,
          ),
          Padding(
            padding: EdgeInsets.all(35),
            child: Text(
              "Pilot",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.elliptical(360, 90)),
                    color: Colors.blue),
                child: GridView.count(
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  crossAxisCount: 3,
                  padding: EdgeInsets.all(40),
                  children: _showList,
                )),
          )
        ],
      )),
    );
  }

  void firebaseMesagingConfig() async {
    var _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.subscribeToTopic("alarm");
    _firebaseMessaging.configure(
        onLaunch: (Map<String, dynamic> message) async {},
        onMessage: (Map<String, dynamic> message) async {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Alert Dialog title"),
                content: Text("Alert Dialog body"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        onResume: (Map<String, dynamic> message) async {});
  }

  void initLists() {
    //mainList
    _mainList.add(ListItem(
      Icon(Icons.camera),
      "Camera",
      () => {
        setState(() => {_showList = _cameraList})
      },
    ));
    //cameraList
    _cameraList.add(ListItem(
        Icon(Icons.arrow_back),
        "back",
        () => {
              setState(() => {_showList = _mainList})
            }));
    _cameraList.add(CameraArmed());
    _cameraList.add(CameraAlarm());
    _cameraList.add(ListItem(Icon(Icons.camera_roll), "photos",
        () => {(_cameraList[3] as ListItem).state.navigateTo("/photos")}));

    _showList = _mainList;
  }
}

class ListItem extends StatefulWidget {
  Icon _icon;
  String _text;
  Function _function;
  Color color = Colors.blue[400];
  _ListItemState state;

  ListItem(Icon icon, String text, Function function, {this.color}) {
    if (color == null) this.color = Colors.blue[400];
    _text = text;
    _icon = icon;
    _function = function;
  }

  @override
  _ListItemState createState() => state = _ListItemState();
}

class _ListItemState extends State<ListItem> {
  void navigateTo(String to) {
    Navigator.pushNamed(context, to);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//                    color: Colors.blueAccent,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: widget.color),
        child: Column(
          children: <Widget>[
            IconButton(
              icon: widget._icon,
              onPressed: widget._function,
              iconSize: 50,
            ),
            Text(
              widget._text,
              style: TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ));
  }
}
