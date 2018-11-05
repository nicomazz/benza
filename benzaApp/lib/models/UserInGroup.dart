import 'package:benza/models/User.dart';
import 'package:latlong/latlong.dart';

class UserInGroup {
  final User user;
  final DateTime specifiedTime;
  final String comment;
  final LatLng startPosition;


  UserInGroup({this.user, this.specifiedTime, this.comment, this.startPosition});

  factory UserInGroup.fromJson(Map<String, dynamic> json) {
    return UserInGroup(
        user: User.fromJson(json["user"]),
        specifiedTime: DateTime(json["specifiedTime"]),
        comment: json["comment"],
        startPosition: LatLng(json["start_lat"],json["start_lng"])
    );
  }

}