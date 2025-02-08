class ToDoElement {
  final String description;
  int notificationID;
  String id = "";
  ToDoElement(
      {required this.description, this.id = "", this.notificationID = -1});

  factory ToDoElement.fromJson(Map<String, dynamic> json, String id) {
    return ToDoElement(
        description: json['description'],
        notificationID: json["notificationID"],
        id: id);
  }

  Map<String, dynamic> toJson() {
    return {"description": description, "notificationID": notificationID};
  }
}
