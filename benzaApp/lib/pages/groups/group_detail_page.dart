import 'package:benza/models/Group.dart';
import 'package:benza/pages/chat/chat_page.dart';
import 'package:benza/pages/groups/group_list_item.dart';
import 'package:benza/services/gmaps.dart';

import 'package:flutter/material.dart';


class GroupDetailPage extends StatelessWidget {
  final Group group;

  GroupDetailPage(this.group);

  @override
  Widget build(BuildContext context) {
    var bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final keyboardDisplayed = bottomInset > 0.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    var map = MapsDemo(name: group.name);
    
		var topMapWidget = SizedBox(
      height: keyboardDisplayed ? 0.0 : MediaQuery.of(context).size.height / 4,
      child: Stack(children: <Widget>[map, mapFullScreenFab(context, map)]),
    );
		
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
                    Tab(text: "Offers"),
                    Tab(text: "Create Offer"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ChatPage(),
                  Text("\n\n\n  Here, user will view offers that are not full in group:\n\n  group.group_id = ${group.group_id}\n  group.name = ${group.name}\n  group.location = ${group.location}\n  group.users = ${group.users}"),
                  Text("\n\n\n  Here, user will create offers that will be stored in group: \n\n  group.group_id = ${group.group_id}\n  group.name = ${group.name}\n  group.location = ${group.location}\n  group.users = ${group.users}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            topMapWidget,
            Container(
                decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
											blurRadius: 0.0
										),
                ]),
                child: groupDetails
						),
            tabController,
          ],
        ),
      ),
    );
  }

  mapFullScreenFab(context, map) => Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          mini: true,
          child: Icon(Icons.fullscreen),
          onPressed: () {
            //let's create another view with only the map
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => map));
          },
        ),
      );
}
