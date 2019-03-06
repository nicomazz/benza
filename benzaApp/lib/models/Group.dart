// https://app.quicktype.io/ <3
// To parse this JSON data, do
//
//     final group = groupFromJson(jsonString);

import 'dart:convert';

List<Group> groupFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<Group>.from(jsonData.map((x) => Group.fromJson(x)));
}

String groupToJson(List<Group> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
    return json.encode(dyn);
}

class Group {
    int group_id;
    String name;
    String location;
    List<String> users;

    Group({
        this.group_id,
        this.name,
        this.location,
        this.users,
    });

    factory Group.fromJson(Map<String, dynamic> json) => new Group(
        group_id: json["group_id"],
        name: json["name"],
        location: json["location"],
        users: json["users"].split(", "),
    );

    Map<String, dynamic> toJson() => {
        "group_id": group_id,
        "name": name,
        "location": location,
        "users": new List<dynamic>.from(users.map((x) => x)),
    };
}

// OLD STUFF
/*class Group {
  final int id;
  final String name;
  final Position from, to;
  final List<LatLng> polyline;
  final List<UserInGroup> users;

  Group({this.id, this.name, this.from, this.to, this.users, this.polyline});

  // j[x] is simply mapping the x as <K,V> where K = String and V = dynamic, essentially preparing it for json decoding.

  factory Group.fromJson(Map<String, dynamic> j) {
    var rawusers = j["users"];
    print('rawusers:$rawusers');

    var userList = (json.decode(j["users"]))
        .map((data) => new UserInGroup.fromJson(data))
        .toList();

    //var userList = new UserInGroup.fromJson(j["users"]).toList(); // trying to find a way to return a List<UserInGroup>, currently userList = dynamic.

    List<LatLng> polyline = decodePolyline(j['polyline']);

    return Group(
      id: j['id'],
      name: j['name'],
      polyline: polyline,
      from: j["from_location"],
      to: j["from_location"],
      users: userList,
    );
  }

  toJson() => json.encode(this);
}

//temp workaround, we have to find a library
List<LatLng> decodePolyline(String encoded) {
  List<LatLng> points = new List<LatLng>();
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;
  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;
    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;
    LatLng p = new LatLng(lat / 1E5, lng / 1E5);
    points.add(p);
  }
  return points;
}*/
