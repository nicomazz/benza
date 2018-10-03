import 'package:benza/data/Group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class GroupListItem extends StatefulWidget {
  final Group _group;

  GroupListItem(this._group);

  @override
  GroupListItemState createState() {
    return new GroupListItemState(this._group);
  }
}

class GroupListItemState extends State<GroupListItem> {
  MapController mapController;
  Group group;

  GroupListItemState(this.group);

  @override
  void initState() {
    mapController = new MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var bounds = new LatLngBounds();
      bounds.extend(group.from.latlng);
      bounds.extend(group.to.latlng);
      mapController.fitBounds(bounds,
          options: new FitBoundsOptions(
            padding: new Point<double>(20.0, 20.0),
          ));
    });
    /*
   
    */
  }

  @override
  Widget build(BuildContext context) {
    var points = [widget._group.from.latlng, widget._group.to.latlng];
    var map = SizedBox(
      width: 120.0,
      height: 120.0,
      child: new FlutterMap(
        mapController: mapController,
        options: new MapOptions(
          center: widget._group.from.latlng,
          zoom: 13.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
            additionalOptions: {
              'accessToken': '<PUT_ACCESS_TOKEN_HERE>',
              'id': 'mapbox.streets',
            },
          ),
          PolylineLayerOptions(polylines: [
            Polyline(points: points, strokeWidth: 4.0, color: Colors.purple)
          ])
        ],
      ),
    );

    var text = ListTile(
      leading: map, // const Icon(Icons.done, color: Colors.green),
      title: Text('Destination: ${widget._group.to.name}'),
      subtitle: Text(
          'Depart from ${widget._group.from.name}\n${widget._group.users.length} users inside'),
    );
    var buttons = ButtonTheme.bar(
      // make buttons use the appropriate styles for cards
      child: new ButtonBar(
        children: <Widget>[
          new FlatButton(
            child: const Text('DETAILS'),
            onPressed: () {
              /* ... */
            },
          ),
          new FlatButton(
            child: const Text('JOIN'),
            onPressed: () {
              /* ... */
            },
          ),
        ],
      ),
    );

    return new Card(
      elevation: 3.0,
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: <Widget>[
          map,
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Destination: ${widget._group.to.name}',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    'Depart from ${widget._group.from.name}\n${widget._group.users.length} users inside',
                  style: TextStyle(fontSize: 16.0, color: Colors.black.withOpacity(0.6)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
