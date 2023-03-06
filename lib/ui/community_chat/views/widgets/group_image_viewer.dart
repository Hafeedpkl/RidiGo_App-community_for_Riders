import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class GroupImageViewer extends StatelessWidget {
  GroupImageViewer({super.key, required this.image});
  final image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ))
          ]),
      body: Center(
          child: Container(
        child: PhotoView(
          imageProvider: image,
        ),
      )),
    );
  }
}
