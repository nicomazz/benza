import 'package:benza/pages/chat/chat_page.dart';
import 'package:benza/pages/groups/create_group_page.dart';
import 'package:benza/pages/groups/group_list_page.dart';
import 'package:benza/pages/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class TabElement {
  Widget widget;
  Widget icon;
  String tag;

  TabElement({this.widget, this.icon, this.tag});

}
class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

  final List<TabElement> _children = [
    TabElement(
        widget: CreateGroupPage(),
        icon: Icon(Icons.group_add),
        tag: "New group"),
    TabElement(
        widget: ChatPage(),
        icon: Icon(Icons.chat),
        tag: "Chat"),
    TabElement(widget: GroupList(),
        icon: Icon(Icons.group), tag: "My Groups"),
    TabElement(widget: GroupList(),
        icon: Icon(Icons.directions), tag: "Trips"),
    TabElement(
        widget: ProfileWidget(),
        icon: Icon(Icons.person),
        tag: "Profile"),


  ];

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      title: Text(_children[_currentIndex].tag),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            _logout();
          },
        )
      ],
    );
    return Scaffold(
        appBar: appbar,
        bottomNavigationBar: BottomNavigationBar(
          // type:BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          // this will be set when a new tab is tapped
          onTap: (index) =>
              setState(() {
                _currentIndex = index;
              }),
          items: _children.map((i) =>
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: i.icon,
                title: Text(i.tag),
              ),
          ).toList(),
        ),
        body: _children[_currentIndex].widget);
  }


  _logout() {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushReplacementNamed('/landingpage');
    }).catchError((e) {
      print(e);
    });
  }
}

