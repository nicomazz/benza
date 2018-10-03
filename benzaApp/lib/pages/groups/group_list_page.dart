import 'dart:async';

import 'package:benza/data/Group.dart';
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

  _generateCard(Group group) {
    return new Card(
      elevation: 3.0,
      margin: EdgeInsets.all(10.0),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.done, color: Colors.green),
            title: Text('Destination: ${group.to.name}'),
            subtitle: Text(
                'Depart from ${group.from.name}\n${group.users.length} users inside'),
          ),
          new ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: new ButtonBar(
              children: <Widget>[
                new FlatButton(
                  child: const Text('DETAILS'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                new FlatButton(
                  child: const Text('JOIN'),
                  onPressed: () {
                    /* ... */
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Group> values = snapshot.data;
    print("values: ${values.length}");
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) =>
          _generateCard(values[index]),
    );
  }
}
