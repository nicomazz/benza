import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsDemo extends StatefulWidget {
  final String name; // needed for shared transactions
  String coords;
  MapsDemo({Key key, this.name, this.coords}) : super(key: key);

  @override
  MapsDemoState createState() {
    return new MapsDemoState();
  }
}

class MapsDemoState extends State<MapsDemo> {
  GoogleMapController mapController;
  
  @override
  Widget build(BuildContext context) {
    // Kilau: 57.165657,2.102314
    List<String> actualCoords = widget.coords.split(",");
    var lat = double.parse(actualCoords[0]);
    var lng = double.parse(actualCoords[1]);
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
          initialCameraPosition: new CameraPosition(
            target: LatLng(lat, lng),
            zoom: 10.5,
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
