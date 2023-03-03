// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.wishList,
    required this.email,
    required this.uid,
    required this.profileImage,
  });

  List<dynamic> wishList;
  String email;
  String uid;
  String? profileImage;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        wishList: List<dynamic>.from(json["wishList"].map((x) => x)),
        email: json["email"],
        uid: json["uid"],
        profileImage: json["profileImage"],
      );

  Map<String, dynamic> toJson() => {
        "wishList": List<dynamic>.from(wishList.map((x) => x)),
        "email": email,
        "uid": uid,
        "profileImage": profileImage,
      };
}
