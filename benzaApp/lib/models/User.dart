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
/*
List<User> getRandomUsers() {
var n = Random().nextInt(100);
List<User> generated = [];
for (var i = 0 ; i < n; i++){
generated.add(User(Faker().person.name()));

}
return generated;
}*/