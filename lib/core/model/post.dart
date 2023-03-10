// To parse this JSON data, do
//
//     final userPost = userPostFromJson(jsonString);

import 'dart:convert';

List<UserPost> userPostFromJson(String str) => List<UserPost>.from(json.decode(str).map((x) => UserPost.fromJson(x)));

String userPostToJson(List<UserPost> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserPost {
    UserPost({
        required this.id,
        required this.title,
        required this.description,
        required this.image,
        required this.group,
        required this.eventType,
        required this.expirationDate,
        required this.regMembers,
        required this.createdAt,
        required this.updatedAt,
    });

    String id;
    String title;
    String description;
    String image;
    String group;
    String eventType;
    DateTime expirationDate;
    List<dynamic> regMembers;
    DateTime createdAt;
    DateTime updatedAt;

    factory UserPost.fromJson(Map<String, dynamic> json) => UserPost(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        group: json["group"],
        eventType: json["eventType"],
        expirationDate: DateTime.parse(json["expirationDate"]),
        regMembers: List<dynamic>.from(json["regMembers"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "image": image,
        "group": group,
        "eventType": eventType,
        "expirationDate": expirationDate.toIso8601String(),
        "regMembers": List<dynamic>.from(regMembers.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
