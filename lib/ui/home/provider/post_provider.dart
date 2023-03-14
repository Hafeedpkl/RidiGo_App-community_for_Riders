import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ridigo/core/services/all_services.dart';
import 'package:ridigo/ui/community_chat/model/group_model.dart';

import '../../../core/model/post.dart';
import '../../../core/model/user.dart';

class PostProvider extends ChangeNotifier {
  List<UserPost> ridesList = [];
  List<UserPost> eventList = [];
  List<UserPost> postList = [];
  Future<Group?>? futureGroupData;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final user = FirebaseAuth.instance.currentUser;

  void getPosts() async {
    log('getPosts');
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
  String selectedPostType = 'event';
  void handleRadioValueChange(value) {
    selectedValue = value;
    notifyListeners();
    if (value == 1) {
      selectedPostType = 'event';
      notifyListeners();
    } else if (value == 2) {
      selectedPostType = 'ride';
      notifyListeners();
    }
  }

  String? selectDate;

  void datePick(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
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

  bool checkRegistered({regMembers}) {
    int registerMemberCount = 0;
    for (var member in regMembers) {
      if (member['email'] == user!.email) {
        registerMemberCount++;
      }
    }
    if (registerMemberCount != 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isEventWishlistEnabled = false;
  void eventWishlist() {
    isEventWishlistEnabled = !isEventWishlistEnabled;
    notifyListeners();
  }

  Future<UserModel?>? futureUserData;

  Widget checkWishList({required String postId}) {
    bool? boolcheck;
    futureUserData = AllServices().getUser();
    log(futureUserData.toString());
    return FutureBuilder(
      future: futureUserData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          int count = 0;
          for (var element in data!.wishList) {
            if (element == postId) {
              count++;
            }
          }
          if (count != 0) {
            boolcheck = true;
          } else {
            boolcheck = false;
          }
        }
        return boolcheck == false
            ? IconButton(
                onPressed: () {
                  AllServices().addToWishList(postId: postId);
                },
                icon: const Icon(Icons.bookmark_outline),
                iconSize: 25,
              )
            : IconButton(
                onPressed: () {
                  AllServices().removeFromWishList(postId: postId);
                },
                icon: const Icon(
                  Icons.bookmark,
                  color: Colors.blueAccent,
                ),
                iconSize: 25);
      },
    );
  }

  // bool isWishListed = false;
  // IconButton wishListButton() {
  //   return isWishListed == false
  //       ? IconButton(
  //           iconSize: 25,
  //           onPressed: () {
  //             isWishListed = checkWishList(isWishListed);
  //             notifyListeners();
  //           },
  //           icon: Icon(
  //             Icons.bookmark_border,
  //           ),
  //         )
  //       : IconButton(
  //           onPressed: () {
  //             isWishListed = checkWishList(isWishListed);
  //             notifyListeners();
  //           },
  //           icon: Icon(Icons.bookmark));
  // }
}
