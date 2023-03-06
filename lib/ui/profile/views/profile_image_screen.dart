import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ridigo/common/api_base_url.dart';
import 'package:ridigo/common/api_end_points.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';

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
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  changeImage(context);
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ))
          ]),
      body: Center(
          child: PhotoView(
        imageProvider: image,
      )),
    );
  }

  // Future changeImage(context) async {
  //   final pickedFile = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //   );
  //   if (pickedFile != null) {
  //     pickedImage = File(pickedFile.path);
  //   }
  // }

  void changeImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm',
          ),
          content: const Text('Are you sure to change the image?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('no')),
            TextButton(
                onPressed: () async {
                  await uploadImage(context);
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavScreen(),
                      ));
                },
                child: const Text('yes'))
          ],
        );
      },
    );
  }

  Future<void> uploadImage(context) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user!.getIdToken();
    var dio = Dio();
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      final FormData formData = FormData.fromMap({
        "postImage": await MultipartFile.fromFile(pickedImage!.path,
            contentType: MediaType('Image', 'JPEG')),
        "email": "${user.email}"
      });
      try {
        Response response =
            await dio.post(kBaseUrl + ApiEndPoints.editProfileImage,
                data: formData,
                options: Options(headers: {
                  'authorization': 'Bearer $token',
                }));
        if (response.statusCode == 200 || response.statusCode == 201) {
          log(response.data.toString(), name: 'profile image');
        }
      } on DioError catch (e) {
        log(e.message);
      }
    }
  }
}
