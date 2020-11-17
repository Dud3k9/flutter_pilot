import 'package:flutter/material.dart';
import 'package:flutterpilot/firebase.dart';

class PhotoDownloader extends StatefulWidget {
  @override
  _PhotoDownloaderState createState() => _PhotoDownloaderState();
}

class _PhotoDownloaderState extends State<PhotoDownloader> {
  @override
  Widget build(BuildContext context) {
    String folder = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("Day: " + folder),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Firebase.getFiles(folder),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var iter = snapshot.data.reversed;
            var list = iter.toList();
            return ListView.builder(
              itemCount: snapshot.data.length,
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/show_image",
                        arguments: List.of({
                          folder,
                          index.toString(),
                          snapshot.data.length.toString()
                        }));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        children: <Widget>[
                          Text(list[index].toString()),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 5),
                                  child: Icon(Icons.image))),
                        ],
                      ),
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
