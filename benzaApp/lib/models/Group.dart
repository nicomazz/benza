// https://app.quicktype.io/ <3
// To parse this JSON data, do
//
//     final group = groupFromJson(jsonString);

import 'dart:convert';

///Decodes JSON data into Dart List<Group> object
List<Group> groupFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<Group>.from(jsonData.map((x) => Group.fromJson(x)));
}

///Encodes Dart List<Group> objects in JSON format
String groupToJson(List<Group> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
    return json.encode(dyn);
}

class Group {
    int group_id;
    String name;
    String location;
    List<String> users;
    String coords;

    Group({
        this.group_id,
        this.name,
        this.location,
        this.users,
        this.coords
    });

    factory Group.fromJson(Map<String, dynamic> json) => new Group(
        group_id: json["group_id"],
        name: json["name"],
        location: json["location"],
        //This is a temporary workaround that will need to be addressed as the team implement the Trips feature
        users: json["users"].split(", "),
        coords: json["coords"],
    );

    Map<String, dynamic> toJson() => {
        "group_id": group_id,
        "name": name,
        "location": location,
        "users": new List<dynamic>.from(users.map((x) => x)),
        "coords": coords,
    };
}
