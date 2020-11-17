import 'package:flutter/material.dart';
import 'package:flutterpilot/firebase.dart';

class CameraAlarm extends StatefulWidget {
  @override
  _CameraAlarmState createState() => _CameraAlarmState();
}

class _CameraAlarmState extends State<CameraAlarm> {
  Color color = Colors.red;
  Icon icon = Icon(Icons.do_not_disturb);
  String text = "no saving";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firebase.getAlarm(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data['isAlarm']) {
              color = Colors.green;
              icon = Icon(Icons.save_alt);
              text = "saving";
            } else {
              color = Colors.red;
              icon = Icon(Icons.do_not_disturb);
              text = "no saving";
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
                        if (text == "no saving")
                          Firebase.setAlarm(true)
                        else
                          Firebase.setAlarm(false),
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
