import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ridigo/ui/community_chat/model/group_model.dart';
import 'package:ridigo/ui/community_chat/services/group_services.dart';

class GroupProvider extends ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController groupNameController = TextEditingController();

  List<Group> groupList = [];

  List<Group> indvidualGroupList = [];

  GroupProvider() {
    getGroup();
    getJoinedGroup();
  }

  bool isLoading = false;

  void getGroup() async {
    isLoading = true;
    log('get ', name: 'provider');
    notifyListeners();
    await GroupService().getGroup().then((value) {
      if (value != null) {
        groupList = value;
        notifyListeners();

        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  void getJoinedGroup() async {
    isLoading = true;
    log('get ', name: 'joined');
    notifyListeners();
    await GroupService().joinedGroups().then((value) {
      if (value != null) {
        indvidualGroupList = value;
        notifyListeners();
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  List<Group> foundedJoinList = [];
  void getJoinList() {
    foundedJoinList = groupList;
    notifyListeners();
  }

  void joinGroupRunFilter(String enteredKeyword) {
    List<Group> results = [];
    if (enteredKeyword.isEmpty) {
      results = groupList;
      notifyListeners();
    } else {
      results = groupList
          .where((element) => element.groupName
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    foundedJoinList = results;
    notifyListeners();
  }
}
