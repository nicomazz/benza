import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MyMap extends StatefulWidget {
  final List<LatLng> points;

  const MyMap({Key key, this.points}) : super(key: key);

  @override
  MyMapState createState() {
    return new MyMapState();
  }
}

class MyMapState extends State<MyMap> {
  MapController mapController;

  @override
  void initState() {
    mapController = new MapController();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => fitMapInBound(widget.points, mapController));
  }

  @override
  Widget build(BuildContext context) {
    return new FlutterMap(
      mapController: mapController,
      options: new MapOptions(
        center: widget.points[0] ?? null,
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        PolylineLayerOptions(polylines: [
          Polyline(
              points: widget.points, strokeWidth: 4.0, color: Colors.purple)
        ])
      ],
    );
  }

  fitMapInBound(List<LatLng> points, MapController mapController) {
    var bounds = new LatLngBounds();
    points.forEach((i) => bounds.extend(i));

    mapController.fitBounds(bounds,

        options: new FitBoundsOptions(
          padding: new Point<double>(30.0, 30.0),
        ));
  }
}
