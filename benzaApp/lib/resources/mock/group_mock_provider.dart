import 'dart:convert';
import 'dart:math';

import 'package:benza/models/Group.dart';
import 'package:benza/models/Position.dart';
import 'package:benza/resources/mock/user_mock_provider.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:latlong/latlong.dart';

Client getMockGroupProvider(){
  return MockClient((request) async {
    final Group g = generateRandomGroup();

    return Response(json.encode(g),200);
  });
}

Group generateRandomGroup() {
  var path = generateRandomPath();

  return Group(id: Random().nextInt(100),
      name: Faker().address.city(),
      from: randomPosition(),
      polyline: path,
      to: randomPosition(),
      users: getRandomUsersInGroup());
}

List<LatLng> generateRandomPath() {
  //Validate.inclusiveBetween(-90.0,90.0,_l
  //Validate.inclusiveBetween(-180.0,180.0,
  var start_point = LatLng(Random().nextDouble()* 160.0 - 80, Random().nextDouble()* 340.0 - 170.0);
  List<LatLng> res = [start_point];
  var numberOfPoints = Random().nextInt(50)+5;
  for (var i = 0; i < numberOfPoints; i++) {
    var prec = res.last;
    var new_point = LatLng(prec.latitude + Random().nextDouble() * 0.1 *( Random().nextDouble() > 0.8? 1:-1),
        prec.longitude + Random().nextDouble() * 0.1*( Random().nextDouble() > 0.8? 1:-1));
    res.add(new_point);
  }
  return res;
}
