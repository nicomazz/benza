import 'dart:math';

import 'package:latlong/latlong.dart';

var dummyLocations = [
  Position("Venice", LatLng(45.440845, 12.315515)),
  Position("Glasgow", LatLng(55.864239, -4.251806)),
  Position("Edinburgh", LatLng(55.953251, -3.188267)),
  Position("London", LatLng(51.507351, -0.327758)),
  Position("aergae", LatLng(45.507351, -0.427758)),
  Position("aerger", LatLng(12.507351, -0.527758)),
  Position("Loaergaerndon", LatLng(88.507351, -0.627758)),
  Position("aergaer", LatLng(15.507351, -0.727758)),
  Position("agaga", LatLng(74.507351, -0.827758)),
  Position("gerge", LatLng(32.507351, -0.927758))
];

Position randomPosition() =>
    dummyLocations[Random().nextInt(dummyLocations.length)];

class Position {
  String name;
  LatLng latlng;

  Position(
    this.name,
    this.latlng,
  );


}
