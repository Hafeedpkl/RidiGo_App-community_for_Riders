class ChatModel {
  String name;
  String text;
  String groupId;
  String? email;
  DateTime? time;
  ChatModel(
      {required this.name,
      required this.text,
      required this.groupId,
      this.email,
      this.time});
  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      name: json["name"],
      text: json["text"],
      groupId: json["group"],
      time: DateTime.parse(json["createdAt"]));
  Map<String, dynamic> toJson() => {
        "name": name,
        "text": text,
        "group": groupId,
      };
}
