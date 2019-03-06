import 'dart:async';

import 'package:benza/models/Group.dart';
import 'package:benza/pages/groups/group_detail_page.dart';
import 'package:benza/pages/groups/group_list_item.dart';
import 'package:benza/resources/group_provider.dart';
import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: _getAllGroups(), // successful future returns realGroups
      initialData: new Text('No groups yet!'),
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
    await new Future.delayed(new Duration(
      seconds: 2)
      );
    return realGroupsList;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Group> values = snapshot.data;
    print("Length of List<Group> is ${values.length}");
    return new ListView.builder(
      // this builds the list of groups as more groups are loaded (to a max of itemCount)
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
