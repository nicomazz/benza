import 'dart:async';

import 'package:benza/data/Group.dart';
import 'package:benza/pages/groups/group_detail_page.dart';
import 'package:benza/pages/groups/group_list_item.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );
  }

  Future<List<Group>> _getData() async {
    List<Group> dummyGroups = new List<Group>.generate(
        100, (i) => Group(name: Faker().address.city()));

    //throw new Exception("Danger Will Robinson!!!");

    await new Future.delayed(new Duration(seconds: 0));
    return dummyGroups;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Group> values = snapshot.data;
    print("values: ${values.length}");
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder:
          (BuildContext context, int index) =>
          GroupListItem(values[index], () {

            Navigator
                .of(context)
                .push(
                MaterialPageRoute(
                    builder: (_) => GroupDetailPage(values[index])
                )
            );
          }),
    );
  }
}
