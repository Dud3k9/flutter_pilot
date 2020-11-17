import 'package:flutter/material.dart';
import 'package:flutterpilot/firebase.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ShowImage extends StatefulWidget {
  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    List<String> arguments = ModalRoute.of(context).settings.arguments;
    String folder = arguments[0];
    int fileIndex = int.parse(arguments[1]);
    int size = int.parse(arguments[2]);

    List<String> list = List<String>();
    return Container(
        child: FutureBuilder<Stream<String>>(
            future: Firebase.getImagesStream(folder),
            builder: (context, stream) {
              if (stream.connectionState != ConnectionState.done)
                return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.red, strokeWidth: 10),
                );
              return StreamBuilder<String>(
                stream: stream.data,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    list.add(snapshot.data);
                    return PhotoViewGallery.builder(
                      pageController:
                          PageController(initialPage: fileIndex + 1),
                      scrollPhysics: const FixedExtentScrollPhysics(),
                      builder: (context, int index) {
                        return PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(
                              list[index == 0 ? index : index - 1]),
                          initialScale: PhotoViewComputedScale.contained * 0.8,
                        );
                      },
                      itemCount: size,
                      loadingBuilder: (context, event) => Center(
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            value: event == null
                                ? 0
                                : event.cumulativeBytesLoaded /
                                    event.expectedTotalBytes,
                          ),
                        ),
                      ),
                    );
                  } else
                    return Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.red, strokeWidth: 10),
                    );
                },
              );
            }));
  }
}

//
// class _ShowImageState extends State<ShowImage> {
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> arguments = ModalRoute.of(context).settings.arguments;
//     String folder = arguments[0];
//     int fileIndex = int.parse(arguments[1]);
//     int size = int.parse(arguments[2]);
//     return Container(
//         child: FutureBuilder<List<String>>(
//       future: Firebase.getImages(folder),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return PhotoViewGallery.builder(
//             pageController: PageController(initialPage: fileIndex),
//             scrollPhysics: const FixedExtentScrollPhysics(),
//             builder: (BuildContext context, int index) {
//               return PhotoViewGalleryPageOptions(
//                 imageProvider: NetworkImage(snapshot.data[index].toString()),
//                 initialScale: PhotoViewComputedScale.contained * 0.8,
//               );
//             },
//             itemCount: snapshot.data.length,
//             loadingBuilder: (context, event) => Center(
//               child: Container(
//                 width: 20.0,
//                 height: 20.0,
//                 child: CircularProgressIndicator(
//                   value: event == null
//                       ? 0
//                       : event.cumulativeBytesLoaded / event.expectedTotalBytes,
//                 ),
//               ),
//             ),
//           );
//         } else
//           return Center(
//             child: CircularProgressIndicator(
//                 backgroundColor: Colors.red, strokeWidth: 10),
//           );
//       },
//     ));
//   }
// }
