import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ridigo/common/api_base_url.dart';
import 'package:ridigo/common/api_end_points.dart';
import 'package:ridigo/ui/community_chat/model/group_model.dart';

class GroupService {
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
}
