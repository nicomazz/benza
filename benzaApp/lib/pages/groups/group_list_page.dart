import 'dart:async';

import 'package:benza/models/Group.dart';
import 'package:benza/pages/groups/group_detail_page.dart';
import 'package:benza/pages/groups/group_list_item.dart';
import 'package:benza/resources/mock/group_mock_provider.dart';
//import 'package:benza/resources/group_provider.dart';
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

  /// group_list_page.dart
  /// Returns a list of `Group` objects.
  /// Every `Group` is populated with data from `generateRandomGroup()`
  Future<List<Group>> _getData() async {
    List<Group> dummyGroups = new List<Group>.generate(
        1, (i) => generateRandomGroup());

    await new Future.delayed(new Duration(seconds: 1));
    return dummyGroups;
  }

  // This connects to the API and requests a single group with fetchGroup(), in this case it's the group with group_id=7
  /*
  Future<Group> _getData() async {
    final apiProvider = new GroupDataProvider();
    final realGroup = apiProvider.fetchGroup(7);

    await new Future.delayed(new Duration(seconds: 1)); // delay leaves time for list of groups to be generated
    return realGroup;
  }
  */

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Group> values = snapshot.data;
    print("List<Group> values: ${values.length}");
    return new ListView.builder( // this builds the list of groups as more groups are loaded (to a max of itemCount)
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) =>
          GroupListItem(values[index], () { // builds the individual groups in the list

            Navigator // a navigation stack - the way to move between screens in flutter apps.
                    .of(context)
                .push(MaterialPageRoute(
                    builder: (_) => GroupDetailPage(values[index])));
          }),
    );
  }
}
