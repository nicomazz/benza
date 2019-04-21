import 'package:benza/models/Group.dart';
import 'package:benza/pages/chat/chat_page.dart';
import 'package:benza/pages/groups/group_list_item.dart';
import 'package:benza/services/gmaps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class GroupDetailPage extends StatelessWidget {
  final Group group;

  GroupDetailPage(this.group);

  ///Retrieves the username for a single uid.
  Future getUserData(uid) async {
    DocumentSnapshot usersnapshot;
    usersnapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var data = usersnapshot?.data ?? Map();
    //To access other data stored under the given uid, change the parameter in parentheses (e.g. "name") below
    dynamic username = data["name"].toString();
    return username;
  }

  @override
  Widget build(BuildContext context) {
    var bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final keyboardDisplayed = bottomInset > 0.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    //The map widget. This is how we access the actual map tile.
    var map = MapsDemo(name: group.name, coords: group.coords);

    //This is the box that contains the map widget. 
    //This widget disappears if the device's keyboard is displayed, leaving more room to view the chat.
    var topMapWidget = SizedBox(
      height: keyboardDisplayed ? 0.0 : MediaQuery.of(context).size.height / 4,
      child: Stack(children: <Widget>[map, mapFullScreenFab(context, map)]),
    );

    //This widget contains group information, including: Name, Location and Join button.
    var groupDetails = Hero(
      tag: "group_item_details_${this.group.name}",
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Material(
                child: keyboardDisplayed
                    ? SizedBox(
                        height: statusBarHeight,
                      )
                    : GroupItemTextDescription(group: this.group)),
          ),
        ],
      ),
    );

    //This widget displays the three tabs: Chat, Trips and Members.
    var tabController = Expanded(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: Offset(0.0, 5.0),
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2.0),
              ]),
              child: Material(
                color: Colors.grey[50],
                child: TabBar(
                  indicatorColor: Colors.blue,
                  labelColor: Colors.blue,
                  tabs: [
                    Tab(text: "Chat"),
                    Tab(text: "Trips"),
                    Tab(text: "Members"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ChatPage(this.group.group_id),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                          "This feature has been temporarily discontinued."),
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: group.users.length ,
                    itemBuilder: (BuildContext context, int index) {
                      getUserData(group.users[index]).then(
                        (value) {
                          print("Username number $index: $value");
                        },
                      );
                      return ListTile(
                        contentPadding: EdgeInsets.only(bottom: 5.0),
                        leading: InkWell(
                          child: CircleAvatar(
                            radius: 20.0,
                          ),
                        ),
                        title: Text(group.users[index]),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    //The return statement for our initial detail widget. Puts all the elements together in a scaffold, ready
    //for the user's screen.
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            topMapWidget,
            Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3), blurRadius: 0.0),
                ]),
                child: groupDetails),
            tabController,                      
          ],
        ),
      ),
    );
  }

  ///Creates a full screen view of the map tile associated with a group
  mapFullScreenFab(context, map) => Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          mini: true,
          child: Icon(Icons.fullscreen),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => map));
          },
        ),
      );
}
