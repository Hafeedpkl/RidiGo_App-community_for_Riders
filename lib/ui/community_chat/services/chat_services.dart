import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ridigo/common/api_base_url.dart';
import 'package:ridigo/common/api_end_points.dart';
import 'package:ridigo/ui/community_chat/model/chat_model.dart';

class ChatServices {
  Dio dio = Dio();
  Future<List<ChatModel>?> getMessages({required groupId}) async {
    try {
      Response response = await dio
          .post(kBaseUrl + ApiEndPoints.message, data: {"details": "$groupId"});
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
