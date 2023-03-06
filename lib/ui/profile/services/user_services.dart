import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ridigo/common/api_base_url.dart';
import 'package:ridigo/common/api_end_points.dart';
import 'package:ridigo/core/model/user.dart';

class UserServices {
  final user = FirebaseAuth.instance.currentUser!;
  Dio dio = Dio();

  Future<UserModel?> getUser() async {
    final token = await user.getIdToken();
    try {
      Response response = await dio.post(kBaseUrl + ApiEndPoints.showProfile,
          data: {"email": "${user.email}"},
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        // log(response.data.toString());
        return UserModel.fromJson(response.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }
}
