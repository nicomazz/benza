import 'package:benza/models/User.dart';
import 'package:latlong/latlong.dart';


class UserInGroup {
  final User user;
  final DateTime specifiedTime;
  final String comment;
  final LatLng startPosition;


  UserInGroup({this.user, this.specifiedTime, this.comment, this.startPosition});

  factory UserInGroup.fromJson(Map<String, dynamic> j) {
    return UserInGroup(
        user: User.fromJson(j["user"]),
        //specifiedTime: DateTime(j["specifiedTime"]),
        //comment: j["comment"],
        //startPosition: LatLng(j["start_lat"],j["start_lng"])
    );
  }

  toList(){
    return this.toList();
  }
}