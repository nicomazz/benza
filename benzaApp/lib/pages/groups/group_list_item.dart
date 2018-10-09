import 'package:benza/data/Group.dart';
import 'package:benza/services/map_utilities.dart';
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
    var points = [widget._group.from.latlng, widget._group.to.latlng];
    var map = SizedBox(
      width: 120.0,
      height: 120.0,
        child: MyMap(points: points, name: widget._group.name)
    );

    var text_description = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Destination: ${widget._group.to.name}',
            style: TextStyle(
                fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Depart from ${widget._group.from.name}\n${widget._group
                .users.length} users inside',
            style: TextStyle(
                fontSize: 16.0, color: Colors.black.withOpacity(0.6)),
          )
        ],
      ),
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

    return GestureDetector(
      onTap: () => widget.onTap(),
      child: new Card(
        elevation: 3.0,
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: <Widget>[
            Material(child: map),
            Hero(
                tag: "group_item_details_${widget._group.name}",
                child: Material(
                    child: GroupItemTextDescription(group: widget._group)))

          ],
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
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Destination: ${group.to.name}',
            style: TextStyle(
                fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Depart from ${group.from.name}\n${group
                .users.length} users inside',
            style: TextStyle(
                fontSize: 16.0, color: Colors.black.withOpacity(0.6)),
          )
        ],
      ),
    );
  }
}
