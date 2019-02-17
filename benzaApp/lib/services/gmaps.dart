import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsDemo extends StatefulWidget {
  final String name; // needed for shared transactions
  const MapsDemo({Key key, this.name}) : super(key: key);

  @override
  MapsDemoState createState() {
    return new MapsDemoState();
  }
}

class MapsDemoState extends State<MapsDemo> {
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300.0,
                maxHeight: 420.0,
                minWidth: 120.0,
                minHeight: 120.0,
              ),
              child: Container(
                margin: new EdgeInsets.all(8.0),
                constraints: BoxConstraints.expand(),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(57.1656210, -2.1021930), //Kilau
                    zoom: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}