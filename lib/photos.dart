import 'package:flutter/material.dart';
import 'package:flutterpilot/firebase.dart';

class Photos extends StatefulWidget {
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("Photos"),
      ),
      body: FutureBuilder<List<String>>(
        future: Firebase.getFolders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/photos_downloader",arguments: snapshot.data[index]);
                  },
                  child: Card(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(snapshot.data[index])
                    ),
                    margin: EdgeInsets.all(5),
                    elevation: 5,
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.red, strokeWidth: 10),
            );
          }
        },
      ),
    );
  }
}
