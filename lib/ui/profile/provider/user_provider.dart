import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ridigo/core/model/user.dart';
import 'package:ridigo/ui/profile/services/user_services.dart';

class UserProvider extends ChangeNotifier {
  String userName = 'User';
  Future<UserModel?>? futureUserData;
  void getUser() async {
    futureUserData = UserServices().getUser();
    log(futureUserData.toString());
  }
}
