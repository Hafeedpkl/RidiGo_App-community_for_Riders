import 'package:flutter/material.dart';
import 'package:ridigo/core/services/all_services.dart';
import 'package:ridigo/ui/community_chat/model/group_model.dart';

import '../../../core/model/post.dart';

class PostProvider extends ChangeNotifier {
  List<UserPost> ridesList = [];
  List<UserPost> eventList = [];
  List<UserPost> postList = [];
  Future<Group?>? futureGroupData;

  bool isLoading = false;
  PostProvider() {
    getEvents();
  }
  void getEvents() async {
    isLoading = true;
    notifyListeners();
    await AllServices().getPosts().then((value) {
      if (value != null) {
        postList = value;
        notifyListeners();
        for (var e in postList) {
          if (e.eventType != 'ride') {
            eventList.add(e);
            notifyListeners();
          } else {
            ridesList.add(e);
            notifyListeners();
          }
        }
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  // void getUser() async {
  //   futureUserData = AllServices().getUser();
  //   log(futureUserData.toString(), name: 'post/user');
  // }
  void openGroup({groupId}) {
    futureGroupData = AllServices().openGroup(groupId: groupId);
  }
}
