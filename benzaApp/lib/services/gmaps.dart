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
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: Container(
        //margin: new EdgeInsets.all(0.0),
        constraints: BoxConstraints.expand(),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(57.1656210, -2.1021930), //Kilau
            zoom: 16.0,
          ),
          myLocationEnabled: false,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
