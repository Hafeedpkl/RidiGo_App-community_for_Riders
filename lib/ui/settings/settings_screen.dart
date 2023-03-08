import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ridigo/common/api_base_url.dart';

import '../../common/api_end_points.dart';

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
            const ElevatedButton(
              onPressed: checkGet,
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
