import 'package:benza/data/Group.dart';
import 'package:benza/pages/chat/chat_page.dart';
import 'package:benza/pages/groups/group_list_item.dart';
import 'package:benza/services/map_utilities.dart';
import 'package:flutter/material.dart';

class GroupDetailPage extends StatelessWidget {
  final Group group;

  GroupDetailPage(this.group);

  @override
  Widget build(BuildContext context) {
    var map = new MyMap(
      points: [group.from.latlng, group.to.latlng],
        name: group.name
    );

    return Scaffold(

      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              child: Stack(
                  children: <Widget>[
                    map,
                    Container(
                      padding: EdgeInsets.all(10.0),
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        mini: true,
                        child: Icon(Icons.fullscreen),
                        onPressed: () {
                          Navigator
                              .of(context)
                              .push(
                              MaterialPageRoute(
                                  builder: (_) => map
                              )
                          );
                        },
                      ),
                    )
                  ]
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.3), blurRadius: 10.0),
                  ]
              ),
              child: Hero(
                  tag: "group_item_details_${this.group.name}",
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Material(
                            child: GroupItemTextDescription(group: this.group)),
                      ),
                    ],
                  )),
            ),
            Divider(height: 1.0,),
            Expanded(child: ChatPage()),
          ],
        ),
      ),
    );
  }
}
