import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Firebase {
  static const platform = const MethodChannel('flutter.native/helper');
  static final firestore = Firestore.instance;
  static final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://monitoring-6b337.appspot.com');

  static void setArmed(bool isArmed) {
    Map<String, bool> map = {'isArmed': isArmed};
    firestore.collection("database").document("info").updateData(map);
  }

  static Stream getArmed() {
    return firestore.collection("database").document("info").snapshots();
  }

  static void setAlarm(bool isAlarm) {
    Map<String, bool> map = {'isAlarm': isAlarm};
    firestore.collection("database").document("info").updateData(map);
  }

  static Stream getAlarm() {
    return firestore.collection("database").document("info").snapshots();
  }

  static Future<List<String>> getFolders() async {
    List<String> folders = List<String>();
    await firestore
        .collection("database")
        .document("folders")
        .get()
        .then((value) => value.data.forEach((key, value) {
              folders.add(key);
            }));
    return folders;
  }

  static Future<List> getFiles(String folder) async {
    List response;
    try {
      var result = await platform.invokeMethod('getFiles', {'folder': folder});
      response = (result as List);
    } on PlatformException catch (e) {
      print(e);
    }
    return await response;
  }

  static Future<String> getImage(String folderName, String fileName) async {
    StorageReference pathRef = storage.ref().child(folderName + "/" + fileName);
    String url = await pathRef.getDownloadURL() as String;
    return await url;
  }

  static Future<List<String>> getImages(String folderName) async {
    var files = await getFiles(folderName);
    var listUrl = List<String>();
    for (int i = 0; i < files.length; i++) {
      var url = await getImage(folderName, files[i].toString());
      listUrl.add(url);
    }
    return listUrl;
  }

  static Future<List<Future<String>>> getImages1(String folderName) async {
    var files = await getFiles(folderName);
    files = files.reversed.toList();
    var listUrl = List<Future<String>>();
    for (int i = 0; i < files.length; i++) {
      var url = getImage(folderName, files[i].toString());
      listUrl.add(url);
    }
    return listUrl;
  }

  static Future<Stream<String>> getImagesStream(String folderName) async {
    return Stream.fromFutures(await getImages1(folderName));
  }
}
