import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridigo/common/api_base_url.dart';
import 'package:ridigo/core/services/all_services.dart';

import '../../common/api_end_points.dart';
import '../profile/model/saved_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future<SaveModel?>? futureData;
    String image = 'public\\Profile\\2023-02-23T04-46-56.232Zimages.png';
    futureData = getSavedList();
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
                // getSavedList();
                AllServices().getJoinedEventsRides();
              },
              child: const Text('Get'),
            ),
            // FutureBuilder(
            //   future: futureData,
            //   builder: (context, snapshot) {
            //     final data = snapshot.data;
            //     log(data.toString());
            //     return Container(
            //       color: Colors.amber,
            //       child: ListView.builder(
            //         shrinkWrap: true,
            //         itemCount: 10,
            //         itemBuilder: (context, index) {
            //           return Text(data!.email);
            //         },
            //       ),
            //     );
            //   },
            // )
          ],
        ),
      )),
    );
  }

  Future<SaveModel?>? getSavedList() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user!.getIdToken();
    var dio = Dio();
    try {
      Response response =
          await dio.post('http://192.168.132.15:3000/api/userPosts/savedItems',
              data: {"email": user.email},
              options: Options(headers: {
                'authorization': 'Bearer $token',
              }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString(), name: 'getSavedList');
        return SaveModel.fromJson(response.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      log(e.message, name: 'getSavedList');
    }
    return null;
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
      // ignore: avoid_print
      print(response.data.toString());
    } else {
      log('error');
    }
  } on DioError catch (e) {
    // ignore: avoid_print
    print(e);
  }
}
