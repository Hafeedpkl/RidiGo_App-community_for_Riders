import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridigo/core/model/post.dart';
import 'package:ridigo/core/model/user.dart';
import 'package:ridigo/core/services/all_services.dart';

class UserProvider extends ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;
  String userName = 'User';
  Future<UserModel?>? futureUserData;
  void getUser() async {
    futureUserData = AllServices().getUser();
    log(futureUserData.toString());
  }


}
