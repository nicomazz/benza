/*import 'dart:convert';
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

    return Response(json.encode(g), 200);
  });
}

Group generateRandomGroup() {
  //var path = generateRandomPath();

  return Group(
      id: Random().nextInt(100),
      name: Faker().address.city(),
      from: LatLng(57.1656210, -2.1021930),
      //polyline: path,
      to: LatLng(57.1656220, -2.1021940),
      //users: getRandomUsersInGroup());
      users: ['blah','blah1'],);
}

List<LatLng> generateRandomPath() {
  //Validate.inclusiveBetween(-90.0,90.0,_l
  //Validate.inclusiveBetween(-180.0,180.0,
  var start_point = LatLng(Random().nextDouble() * 160.0 - 80,
      Random().nextDouble() * 340.0 - 170.0);
  List<LatLng> res = [start_point];
  var numberOfPoints = 10;
  for (var i = 0; i < numberOfPoints; i++) {
    var prec = res.last;
    var newPoint = LatLng(
        prec.latitude +
            Random().nextDouble() *
                0.1 *
                (Random().nextDouble() > 0.8 ? 1 : -1),
        prec.longitude +
            Random().nextDouble() *
                0.1 *
                (Random().nextDouble() > 0.8 ? 1 : -1));
    res.add(newPoint);
    
  }
  print('List<LatLng> given by generator: $res');
  return res;
}
*/