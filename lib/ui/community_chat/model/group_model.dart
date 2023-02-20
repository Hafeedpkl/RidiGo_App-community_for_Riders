class Group {
  Group({
    required this.id,
    required this.admin,
    required this.groupName,
    required this.members,
    required this.events,
    required this.rides,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String admin;
  String groupName;
  List<String> members;
  List<dynamic> events;
  List<dynamic> rides;
  DateTime createdAt;
  DateTime updatedAt;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["_id"],
        admin: json["admin"],
        groupName: json["groupName"],
        members: List<String>.from(json["members"].map((x) => x)),
        events: List<dynamic>.from(json["events"].map((x) => x)),
        rides: List<dynamic>.from(json["rides"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "admin": admin,
        "groupName": groupName,
        "members": List<dynamic>.from(members.map((x) => x)),
        "events": List<dynamic>.from(events.map((x) => x)),
        "rides": List<dynamic>.from(rides.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
