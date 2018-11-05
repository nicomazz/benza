import 'dart:math';

import 'package:benza/models/Position.dart';
import 'package:benza/models/User.dart';
import 'package:benza/models/UserInGroup.dart';
import 'package:faker/faker.dart';

User generateRandomUser() => User(
    name: Faker().person.name(),
    id: Faker().guid.guid()
);

getRandomUsers() =>
    List<User>.generate(Random().nextInt(100), (_) => generateRandomUser());

List<UserInGroup> getRandomUsersInGroup() {
  List randomUsers = getRandomUsers();
  return List<UserInGroup>.generate(randomUsers.length,
    (i) => UserInGroup(
        comment: "no comment",
        specifiedTime: DateTime.now(),
        startPosition: randomPosition().latlng)
  );
}