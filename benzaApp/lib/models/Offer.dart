import 'dart:convert';

import 'package:benza/models/UserInGroup.dart';

class Offer {
  final String userId;
  final String groupId;
  final int capacity;
  final List<UserInGroup> usersInside;

  Offer({this.userId, this.groupId, this.capacity, this.usersInside});

  factory Offer.fromJson(Map<String, dynamic> j) {
    var user_list  = (json.decode(j["usersInside"]) as List)
        .map((data) => new UserInGroup.fromJson(data))
        .toList();
    return Offer(
       userId: j["user_id"],
      groupId: j["group_id"],
      capacity: j["capacity"],
      usersInside: user_list

    );
  }}