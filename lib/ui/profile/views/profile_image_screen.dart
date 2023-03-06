import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

class ProfileImageScreen extends StatelessWidget {
  ProfileImageScreen({super.key, required this.image});
  final image;
  File? pickedImage;
  final _picker = ImagePicker();
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
                onPressed: () {
                  // changeImage(context);
                  confirmImage(pickedImage, context);
                },
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

  Future changeImage(context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
    }
  }

  void confirmImage(File? image, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirm',
          ),
          content: Text('Are you sure to change the image?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('no')),
            TextButton(onPressed: () {
              
            }, child: Text('yes'))
          ],
        );
      },
    );
  }
}
