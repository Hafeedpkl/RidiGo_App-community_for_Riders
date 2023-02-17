import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ridigo/common/api_base_url.dart';

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
  var response = await dio.post("${kBaseUrl}profile/showProfile",
      data: {'email': 'hafeed123@gmail.com'});

  print(response.statusCode);
  print(response.data.toString());
}
