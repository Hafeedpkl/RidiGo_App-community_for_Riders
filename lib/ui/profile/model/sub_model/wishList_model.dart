class WishList {
    WishList({
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
        required this.v,
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
    int v;

    factory WishList.fromJson(Map<String, dynamic> json) => WishList(
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
        v: json["__v"],
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
        "__v": v,
    };
}