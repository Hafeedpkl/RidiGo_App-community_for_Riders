import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:ridigo/ui/community_chat/model/group_model.dart';
import 'package:ridigo/ui/community_chat/services/group_services.dart';

class GroupProvider extends ChangeNotifier {
  List<Group> groupList = [];
  var dummy = 'variable';
  GroupProvider() {
    getGroup();
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
}
