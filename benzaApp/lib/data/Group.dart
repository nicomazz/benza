import 'package:benza/data/Position.dart';
import 'package:benza/data/User.dart';

class Group {
  final String name;
  Position from, to;
  List<User> users;

  Group({this.name, this.from, this.to, this.users}) {
    if (from is! Position) from = Position.randomPosition();
    if (to is! Position) to = Position.randomPosition();
    if (users is! List<User>) users = User.getRandomUsers();
  }
}
