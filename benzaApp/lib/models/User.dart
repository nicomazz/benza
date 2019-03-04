import 'dart:math';
import 'package:faker/faker.dart';

class User {
  final String name;
  final String id;

  User({this.name, this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      id: json["id"]
    );
  }
}