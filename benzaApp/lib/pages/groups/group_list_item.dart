import 'dart:async';

import 'package:benza/models/Group.dart';
import 'package:benza/services/gmaps.dart';
import 'package:benza/resources/group_provider.dart';
//import 'package:benza/services/user_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    var map = SizedBox(
      width: 120.0,
      height: 120.0,
      child: Container(
        constraints: BoxConstraints.expand(),
        child: MapsDemo(name: widget._group.name, coords: widget._group.coords),
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
                  child: GroupItemTextDescription(group: widget._group)),
              Button(group: widget._group),
            ],
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final Group group;

  const Button({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          child: const Text('JOIN'),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: () async {
            var currentUser = await FirebaseAuth.instance.currentUser();
            DocumentSnapshot userToAdd = await Firestore.instance
                .collection('users')
                .document(currentUser.uid)
                .get();
            var data = userToAdd?.data ?? Map();
            String uid = data["uid"];
            print("\nTrying to POST: group name = ${group.name}, uid = $uid\n");
            var apiProvider = new GroupDataProvider();
            apiProvider.addToGroup(group.name, uid.toString());
          },
        )
      ],
    );
  }
}

class GroupItemTextDescription extends StatelessWidget {
  final Group group;
  const GroupItemTextDescription({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${group.name}',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            '${group.location}',
            style:
                TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 5.0,
          ),
          /* FlatButton(
            child: const Text('JOIN'),
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: () async {
              var currentUser = await FirebaseAuth.instance.currentUser();
              DocumentSnapshot userToAdd = await Firestore.instance
                  .collection('users')
                  .document(currentUser.uid)
                  .get();
              var data = userToAdd?.data ?? Map();
              String uid = data["uid"];
              print(
                  "\nTrying to POST: group name = ${group.name}, uid = $uid\n");
              var apiProvider = new GroupDataProvider();
              apiProvider.addToGroup(group.name, uid.toString());
            },
          ) */
        ],
      ),
    );
  }
}
