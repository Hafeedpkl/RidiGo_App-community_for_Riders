import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ridigo/core/services/all_services.dart';
import 'package:ridigo/ui/community_chat/model/group_model.dart';

import '../../../core/model/post.dart';

class PostProvider extends ChangeNotifier {
  List<UserPost> ridesList = [];
  List<UserPost> eventList = [];
  List<UserPost> postList = [];
  Future<Group?>? futureGroupData;
 final formKey = GlobalKey<FormState>();
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

  int selectedValue = 1;

  void handleRadioValueChange(int value) {
    selectedValue = value;
    notifyListeners();
  }

  String? selectDate;

  void datePick(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2005),
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      print(pickedDate);

      selectDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      print(selectDate);
      notifyListeners();
    }
  }

  File? image;
  void getImage() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      print('no Image Selected');
    }
  }
}
