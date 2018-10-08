import 'package:benza/data/Group.dart';
import 'package:benza/pages/chat/chat_page.dart';
import 'package:benza/pages/groups/group_list_item.dart';
import 'package:benza/pages/placeholder_page.dart';
import 'package:benza/services/map_utilities.dart';
import 'package:flutter/material.dart';

class GroupDetailPage extends StatelessWidget {
  final Group group;

  GroupDetailPage(this.group);

  @override
  Widget build(BuildContext context) {
    var map = new MyMap(
      points: [group.from.latlng, group.to.latlng],
    );

    return Scaffold(

      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Hero(
                  child: map,
                  tag: "group_item_${this.group.name}",
                )),
            Hero(
                tag: "group_item_details_${this.group.name}",
                child: Row(
                  children: <Widget>[
                    Material(child: GroupItemTextDescription(group: this.group)),
                  ],
                )),
            Divider(height: 1.0,),
            Expanded(child: ChatPage()),
          ],
        ),
      ),
    );
  }
}
