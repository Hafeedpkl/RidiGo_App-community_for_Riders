import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ridigo/common/api_base_url.dart';
import 'package:ridigo/common/api_end_points.dart';
import 'package:ridigo/ui/community_chat/model/chat_model.dart';

class ChatServices {
  Dio dio = Dio();
  final user = FirebaseAuth.instance.currentUser;
  Future<List<ChatModel>?> getMessages({required groupId}) async {
    final token = await user!.getIdToken();
    try {
      Response response = await dio.post(kBaseUrl + ApiEndPoints.message,
          data: {"details": "$groupId"},
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      log(response.statusCode.toString(), name: 'get messages');
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<ChatModel> messageList =
            (response.data as List).map((e) => ChatModel.fromJson(e)).toList();
        return messageList;
      } else {
        return null;
      }
    } on DioError catch (e) {
      log(e.message);
    }
    return null;
  }
}
