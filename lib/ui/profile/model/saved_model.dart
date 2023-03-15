import 'dart:convert';

import 'package:ridigo/ui/profile/model/sub_model/wishList_model.dart';

SaveModel saveModelFromJson(String str) => SaveModel.fromJson(json.decode(str));

String saveModelToJson(SaveModel data) => json.encode(data.toJson());

class SaveModel {
  SaveModel({
    required this.id,
    required this.email,
    required this.uid,
    required this.wishList,
  });

  String id;
  String email;
  String uid;
  List<WishList> wishList;

  factory SaveModel.fromJson(Map<String, dynamic> json) => SaveModel(
        id: json["_id"],
        email: json["email"],
        uid: json["uid"],
        wishList: List<WishList>.from(
            json["wishList"].map((x) => WishList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "uid": uid,
        "wishList": List<dynamic>.from(wishList.map((x) => x.toJson())),
      };
}
