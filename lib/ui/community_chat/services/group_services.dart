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
      log('get group');
      Response response = await dio.get(
        kBaseUrl + ApiEndPoints.getgroup,
      );
      log(response.statusCode.toString());
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
}
