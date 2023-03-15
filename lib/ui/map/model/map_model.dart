import 'dart:convert';

List<MapModel> mapModelFromJson(String str) =>
    List<MapModel>.from(json.decode(str).map((x) => MapModel.fromJson(x)));

String mapModelToJson(List<MapModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MapModel {
  MapModel({
    required this.id,
    required this.username,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.expireAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String username;
  String title;
  String description;
  double latitude;
  double longitude;
  DateTime expireAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory MapModel.fromJson(Map<String, dynamic> json) => MapModel(
        id: json["_id"],
        username: json["username"],
        title: json["title"],
        description: json["description"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        expireAt: DateTime.parse(json["expireAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "title": title,
        "description": description,
        "latitude": latitude,
        "longitude": longitude,
        "expireAt": expireAt.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
