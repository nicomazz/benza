import 'dart:async';

import 'package:benza/models/Group.dart';
import 'package:benza/pages/groups/create_group_page.dart';
import 'package:benza/pages/groups/group_detail_page.dart';
import 'package:benza/pages/groups/group_list_item.dart';
import 'package:benza/pages/home_page.dart';
import 'package:benza/resources/group_provider.dart';
import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: _getAllGroups(), // successful future returns realGroups
      //initialData: new Text('No groups yet!'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );
  }

  Future<List<Group>> _getAllGroups() async {
    final apiProvider = new GroupDataProvider();
    final realGroupsList = apiProvider.getAllGroups();
    await new Future.delayed(new Duration(seconds: 2));
    return realGroupsList;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Group> values = snapshot.data;
    print("Length of List<Group> is ${values.length}");
    if (values.length == 0) return noGroups(context);
    return new ListView.builder(
      // this builds a dynamic list of groups up to a max length of itemCount
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) => GroupListItem(
            values[index],
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => GroupDetailPage(values[index])),
              );
            },
          ),
    );
  }
}

Widget noGroups(context) {
  return new Container(
    constraints: BoxConstraints.expand(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'No groups yet!',
          textAlign: TextAlign.center,
        ),
        FlatButton(
          child: const Text('Create Group'),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Oopsie"),
                  content: new Text(
                      "This is a feature that will be created in the future. For now, you can tap on the bottom left icon to create your own group!"),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
          },
        ),
      ],
    ),
  );
}
