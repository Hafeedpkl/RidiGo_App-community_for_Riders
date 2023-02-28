import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ridigo/common/api_base_url.dart';
import 'package:ridigo/common/api_end_points.dart';
import 'package:ridigo/ui/community_chat/model/group_model.dart';

class GroupService {
  final user = FirebaseAuth.instance.currentUser!;

  Dio dio = Dio();
  Future<List<Group>?> getGroup() async {
    try {
      Response response = await dio.get(
        kBaseUrl + ApiEndPoints.getgroup,
      );
      log(response.statusCode.toString(), name: 'getGroup');
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Group> groupList =
            (response.data as List).map((e) => Group.fromJson(e)).toList();
        return groupList;
      } else {
        return null;
      }
    } on DioError catch (e) {
      log(e.message);
    }
    return null;
  }

  Future<List<Group>?> joinedGroups() async {
    try {
      log('joined Group');
      Response response = await dio.get(kBaseUrl + ApiEndPoints.getgroup);
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
      log(e.message);
    }
    return null;
  }

  Future<void> createGroup({roomName}) async {
    try {
      log('create Group');
      Response response = await dio.post(kBaseUrl + ApiEndPoints.createGroup,
          data: '{"adminName":"${user.email}","roomName":"$roomName"}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString(), name: 'createGp');
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }

  Future<void> joinGroup({groupId}) async {
    try {
      log('joined the group');
      Response response = await dio.post(kBaseUrl + ApiEndPoints.joinGroup,
          data: '{"selection":"${groupId}","username":"${user.email}"}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString());
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }
}
