import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/common/api_base_url.dart';
import 'package:ridigo/ui/community_chat/provider/group_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: checkGet,
        child: Text('Get'),
      )),
    );
  }
}

void checkGet() async {
  var dio = Dio();
  log("${kBaseUrl}profile/showProfile");
  try {
    var response = await dio.post('${kBaseUrl}profile/showProfile',
        data: {'email': 'hafeed123@gmail.com'});
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
