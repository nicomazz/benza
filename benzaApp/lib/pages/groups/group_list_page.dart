import 'dart:async';

import 'package:benza/models/Group.dart';
import 'package:benza/pages/groups/group_detail_page.dart';
import 'package:benza/pages/groups/group_list_item.dart';
import 'package:benza/resources/mock/group_mock_provider.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: _getData(), // successful future returns dummyGroups
      initialData: new Text('No groups yet!'),
      builder: (BuildContext context, AsyncSnapshot snapshot) { // evaluates last known state of async computation
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('Loading...');
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
        2, (i) => generateRandomGroup()); // creates list of length 2 & generates random group (from mock_provider) for each entry

    await new Future.delayed(new Duration(seconds: 1)); // delay leaves time for list of groups to be generated
    return dummyGroups;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Group> values = snapshot.data;
    print("List<Group> values: ${values.length}");
    return new ListView.builder( // this builds the list of groups as more groups are loaded (to a max of itemCount)
      itemCount: values.length,
      itemBuilder:
          (BuildContext context, int index) =>
          GroupListItem(values[index], () { // builds the individual groups in the list

            Navigator // a navigation stack - the way to move between screens in flutter apps.
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
