import 'dart:math';

import 'package:latlong/latlong.dart';

var dummyLocations = [
  Position("Venice", LatLng(45.440845, 12.315515)),
  Position("Glasgow", LatLng(55.864239, -4.251806)),
  Position("Edinburgh", LatLng(55.953251, -3.188267)),
  Position("London", LatLng(51.507351, -0.127758))
];

class Position {
  String name;
  LatLng latlng;

  Position(
    this.name,
    this.latlng,
  );

  static randomPosition() =>
      dummyLocations[Random().nextInt(dummyLocations.length)];
}
