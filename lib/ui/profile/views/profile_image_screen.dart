
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ridigo/core/services/all_services.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';

class ProfileImageScreen extends StatelessWidget {
  const ProfileImageScreen({super.key, required this.image});
  // ignore: prefer_typing_uninitialized_variables
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
                  await AllServices().uploadProfileImage(context);
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
}
