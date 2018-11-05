

import 'dart:convert';

import 'package:benza/models/Position.dart';
import 'package:benza/models/User.dart';
import 'package:benza/models/UserInGroup.dart';
import 'package:latlong/latlong.dart';

class Group {
  final int id;
  final String name;
  final Position from, to;
  final List<LatLng> polyline;
  final List<UserInGroup> users;

  Group({this.id,this.name, this.from, this.to, this.users, this.polyline});

  factory Group.fromJson(Map<String, dynamic> j) {
    var user_list  = (json.decode(j["users"]) as List)
        .map((data) => new UserInGroup.fromJson(data))
        .toList();
    List<LatLng> polyline =  decodePolyline(j['polyline']);
    return Group(
      id: j['id'],
      name: j['name'],
      polyline: polyline,
      from : j["from_location"],
      to: j["from_location"],
      users: user_list,
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
}