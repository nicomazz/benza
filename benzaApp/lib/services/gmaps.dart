import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///A Google Maps widget that expands to fit its parent container.
class MapsDemo extends StatefulWidget {
  //This name is what allows the map to display different behaviour based on what group its representing
  final String name;
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
    //This .split() is the result of storing the latlng data as flat string to avoid API problems.
    //It will need to be addressed when Trips are implemented.
    List<String> actualCoords = widget.coords.split(",");
    var lat = double.parse(actualCoords[0]);
    var lng = double.parse(actualCoords[1]);
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: Container(
        constraints: BoxConstraints.expand(),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: new CameraPosition(
            //This is where the map is focused on a specific set of latlng belonging to a group.
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

// Default coords are Kilau 57.165657,2.102314