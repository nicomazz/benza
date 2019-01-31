import 'dart:math';

import 'package:latlong/latlong.dart';

var dummyLocations = [
  Position("Venice", LatLng(45.440845, 12.315515)),
  Position("Glasgow", LatLng(55.864239, -4.251806)),
  Position("Edinburgh", LatLng(55.953251, -3.188267)),
  Position("London", LatLng(51.507351, -0.327758)),
  Position("Neulles", LatLng(45.507351, -0.427758)),
  Position("Boulsa", LatLng(12.507351, -0.527758)),
  Position("Cape Town", LatLng(-33.907395, 18.407043)),
  Position("Mogadishu", LatLng(2.055231, 45.328154)),
  Position("Lviv", LatLng(49.809315, 24.034179)),
  Position("Oslo", LatLng(59.916380, 10.751514))
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
