
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ridigo/core/services/all_services.dart';

import '../../../../common/api_base_url.dart';
import '../../../../common/api_end_points.dart';
import '../../../bottom_navigation/bottom_navigation.dart';
import '../../model/group_model.dart';

// ignore: must_be_immutable
class GroupImageViewer extends StatelessWidget {
  GroupImageViewer({super.key, required this.data});
  Group? data;
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
                  updateImage(data: data, context: context);
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ))
          ]),
      body: Center(
          child: PhotoView(
            imageProvider: getDp(data),
          )),
    );
  }

  void updateImage({Group? data, BuildContext? context}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user!.email == data!.admin) {
      changeImage(context: context, data: data);
    } else {
      Fluttertoast.showToast(
          msg: "Only Admin can edit group icon",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void changeImage({BuildContext? context, Group? data}) {
    showDialog(
      context: context!,
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
                  await AllServices().uploadImage(
                    data: data,
                  );
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

  ImageProvider<Object> getDp(Group? data) {
    if (data!.image != null) {
      return NetworkImage(
        kBaseUrl + ApiEndPoints.getImage + data.image!,
      );
    }
    return Image.asset(
      'assets/images/profile-image.png',
    ).image;
  }
}
