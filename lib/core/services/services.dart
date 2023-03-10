import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/api_base_url.dart';
import '../../common/api_end_points.dart';
import '../../ui/community_chat/model/chat_model.dart';
import '../../ui/community_chat/model/group_model.dart';
import '../model/user.dart';

class Services {
  final user = FirebaseAuth.instance.currentUser!;
  Dio dio = Dio();

  //Group Section
  Future<List<Group>?> getGroup() async {
    final token = await user.getIdToken();
    try {
      Response response = await dio.get(kBaseUrl + ApiEndPoints.getgroup,
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      log(response.statusCode.toString(), name: 'getGroup');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<Group> jsonData =
            (response.data as List).map((e) => Group.fromJson(e)).toList();
        final List<Group> groupList = [];
        for (var data in jsonData) {
          final members = List<String>.from(data.members);
          if (!members.contains('${user.email}')) {
            groupList.add(data);
          }
        }
        return groupList;
      } else {
        return null;
      }
    } on DioError catch (e) {
      log(e.message, name: 'get groups');
    }
    return null;
  }

  Future<List<Group>?> joinedGroups() async {
    final token = await user.getIdToken();
    try {
      Response response = await dio.get(kBaseUrl + ApiEndPoints.getgroup,
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<Group> jsonData =
            (response.data as List).map((e) => Group.fromJson(e)).toList();
        final List<Group> filteredData = [];
        for (var data in jsonData) {
          final members = List<String>.from(data.members);
          if (members.contains('${user.email}')) {
            filteredData.add(data);
          }
        }
        return filteredData;
      } else {
        return null;
      }
    } on DioError catch (e) {
      log(e.message, name: 'joinedGroups');
    }
    return null;
  }

  Future<void> createGroup({roomName}) async {
    final token = await user.getIdToken();
    try {
      log('create Group');
      Response response = await dio.post(kBaseUrl + ApiEndPoints.createGroup,
          data: '{"adminName":"${user.email}","roomName":"$roomName"}',
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString(), name: 'createGp');
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }

  Future<void> joinGroup({groupId}) async {
    final token = await user.getIdToken();
    final List<Group> members;

    try {
      Response response = await dio.post(kBaseUrl + ApiEndPoints.joinGroup,
          data: '{"selection":"${groupId}","username":"${user.email}"}',
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString());
        getGroup();
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }

//Chat Screen

  Future<List<ChatModel>?> getMessages({required groupId}) async {
    final token = await user.getIdToken();
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


  //User section
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
