import 'package:benza/models/Group.dart';
import 'package:benza/services/map_utilities.dart';
import 'package:benza/services/gmaps.dart';
import 'package:flutter/material.dart';

class GroupListItem extends StatefulWidget {
  final Group _group;
  final Function onTap;

  GroupListItem(this._group, this.onTap);

  @override
  GroupListItemState createState() {
    return new GroupListItemState();
  }
}

class GroupListItemState extends State<GroupListItem> {

  @override
  Widget build(BuildContext context) {
    //var points = widget._group.polyline;

    var map = SizedBox(
        width: 120.0,
        height: 120.0,
        // child: MyMap(points: points, name: widget._group.name)
        child: MapsDemo(name: widget._group.name),
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

    return Material(
      child: GestureDetector(
        onTap: () => widget.onTap(),
        child: new Card(
          elevation: 3.0,
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: <Widget>[
              map,
              Hero(
                  tag: "group_item_details_${widget._group.name}",
                  child: GroupItemTextDescription(group: widget._group)
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupItemTextDescription extends StatelessWidget {
  final Group group;

  const GroupItemTextDescription({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${group.to.name}',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Depart from ${group.from.name}\n${group.users.length} people in group',
            style:
                TextStyle(fontSize: 16.0, color: Colors.black.withOpacity(0.6)),
          )
        ],
      ),
    );
  }
}
