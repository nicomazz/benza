import 'dart:math';
import 'package:faker/faker.dart';

class User {
  String name;


  User(this.name);

  static List<User> getRandomUsers() {
    var n = Random().nextInt(100);
    List<User> generated = [];
    for (var i = 0 ; i < n; i++){
      generated.add(User(Faker().person.name()));

    }
    return generated;
  }
}