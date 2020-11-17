import 'package:flutter/material.dart';
import 'package:flutterpilot/firebase.dart';

class CameraArmed extends StatefulWidget {
  @override
  _CameraArmedState createState() => _CameraArmedState();
}

class _CameraArmedState extends State<CameraArmed> {
  Color color = Colors.red;
  Icon icon = Icon(Icons.videocam_off);
  String text = "not armed";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firebase.getArmed(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data['isArmed']) {
              color = Colors.green;
              icon = Icon(Icons.videocam);
              text = "armed";
            } else {
              color = Colors.red;
              icon = Icon(Icons.videocam_off);
              text = "not armed";
            }

            return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: color),
                child: Column(
                  children: <Widget>[
                    IconButton(
                      icon: icon,
                      onPressed: () => {
                        if (text == "not armed")
                          Firebase.setArmed(true)
                        else
                          Firebase.setArmed(false),
                        this.setState(() {})
                      },
                      iconSize: 50,
                    ),
                    Text(
                      text,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ));
          } else {
            return CircularProgressIndicator(
                backgroundColor: Colors.red, strokeWidth: 10);
          }
        });
  }
}
