import 'package:benza/pages/groups/group_list_page.dart';
import 'package:benza/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    ProfileWidget(),
    GroupList(),
    PlaceholderWidget(Colors.yellow)
  ];
  final List<String> _childrenNames = ["Request", "Groups", "Trips"];

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      title: Text(_childrenNames[_currentIndex]),
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
            currentIndex: _currentIndex,
            // this will be set when a new tab is tapped
            onTap: (index) => setState(() {
                  _currentIndex = index;
                }),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.group_add),
                title: Text(_childrenNames[0]),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                title: Text(_childrenNames[1]),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions),
                title: Text(_childrenNames[2]),
              )
            ]),
        body: _children[_currentIndex]);
  }

  /*

   Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You are now logged in'),
              SizedBox(
                height: 15.0,
              ),
              OutlineButton(
                borderSide: BorderSide(
                    color: Colors.red, style: BorderStyle.solid, width: 3.0),
                child: Text('Logout'),
                onPressed: () {
                  _logout();
                },
              ),
            ],
          ),
        ),
      ),
    */

  _logout() {
    FirebaseAuth.instance.signOut().then((value) {
      // Navigator.of(context).pushReplacementNamed('/landingpage');
    }).catchError((e) {
      print(e);
    });
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
