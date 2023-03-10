import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ridigo/core/model/user.dart';
import 'package:ridigo/core/services/services.dart';

class UserProvider extends ChangeNotifier {
  String userName = 'User';
  Future<UserModel?>? futureUserData;
  void getUser() async {
    futureUserData = Services().getUser();
    log(futureUserData.toString());
  }
}
