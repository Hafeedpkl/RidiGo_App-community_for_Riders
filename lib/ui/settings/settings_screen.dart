import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridigo/common/api_base_url.dart';

import '../../common/api_end_points.dart';
import '../community_chat/model/group_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String image = 'public\\Profile\\2023-02-23T04-46-56.232Zimages.png';

    //
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.amber,
              backgroundImage:
                  NetworkImage(kBaseUrl + ApiEndPoints.getImage + image),
            ),
            ElevatedButton(
              onPressed: () async {
                openGroup(groupId: '63f3765d22bee0f28806b361');
              },
              child: Text('Get'),
            ),
            // FutureBuilder(
            //   future: token,
            //   builder: (context, snapshot) {
            //     return Text(snapshot.data);
            //   },
            // )
          ],
        ),
      )),
    );
  }
}

void checkGet() async {
  final user = FirebaseAuth.instance.currentUser;
  final token = user!.getIdToken();
  var dio = Dio();
  log("${kBaseUrl}profile/showProfile");
  try {
    var response = await dio.post(kBaseUrl + ApiEndPoints.showProfile,
        data: {'email': 'hafeed123@gmail.com'},
        options: Options(headers: {
          'authorization': 'Bearer $token',
        }));
    if (response.statusCode == 200) {
      log('done');
      print(response.data.toString());
    } else {
      log('error');
    }
  } on DioError catch (e) {
    print(e);
  }
}

Future<Group?> openGroup({groupId}) async {
  var dio = Dio();
  final user = FirebaseAuth.instance.currentUser;
  final token = await user!.getIdToken();
  try {
    Response response = await dio.post(kBaseUrl + ApiEndPoints.openGroup,
        data: {"details": "${groupId}"},
        options: Options(headers: {
          'authorization': 'Bearer $token',
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      log(response.data.toString());
      return Group.fromJson(response.data);
    } else {
      return null;
    }
  } on DioError catch (e) {
    print(e.message);
  }
  return null;
}
