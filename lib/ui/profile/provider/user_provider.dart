import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ridigo/core/model/user.dart';
import 'package:ridigo/core/services/all_services.dart';

class UserProvider extends ChangeNotifier {
  String userName = 'User';
  Future<UserModel?>? futureUserData;
  void getUser() async {
    futureUserData = AllServices().getUser();
    log(futureUserData.toString());
  }
}
