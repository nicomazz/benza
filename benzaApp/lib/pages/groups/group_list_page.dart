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
      //If this future is successful, it will return a none-null value
      future: _getAllGroups(),
      //While the future is being asynchronously computed, the page's builder has a range of options for the content it should display.
      //The content it chooses depends upon the state of the computation.
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

  ///Accesses the client method in the group_provider.dart file in order to connect to the groups database
  ///A built-in delay of 2 seconds provides breathing room in case of latency and makes sure that the response has been fully received before returning a value
  Future<List<Group>> _getAllGroups() async {
    final apiProvider = new GroupDataProvider();
    final realGroupsList = apiProvider.getAllGroups();
    await new Future.delayed(new Duration(seconds: 2));
    return realGroupsList;
  }

  ///Outputs the data provided by _getAllGroups() as a carefully designed list
  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    //This is where the raw data coming back from the API gets converted into Dart objects
    //For details about this process, look at ../models/Group.dart
    List<Group> values = snapshot.data;
    print("Length of List<Group> is ${values.length}");
    //If no groups have been created yet, prompt the user to create one
    if (values.length == 0) return noGroups(context);
    //Builds a dynamic list of groups up to a max length of itemCount 
    //The list will build new items as they are needed, so off-screen elements aren't loaded (very efficient)
    return new ListView.builder(
      itemCount: values.length,
      //Every item in the list is its own widget, defined in group_list_item.dart
      itemBuilder: (BuildContext context, int index) => GroupListItem(
            //This is the group that is being passed to GroupListItem
            values[index],
            //This is GroupListItem's onTap() method
            //It will load a detailed view of the group in question using group_detail_page.dart
            () {
              Navigator.of(context).push(
                //This will overwrite the app's usual layout (i.e. bottom nav bar and top app bar)
                MaterialPageRoute(
                    builder: (_) => GroupDetailPage(values[index])),
              );
            },
          ),
    );
  }
}

///Shows 'No groups yet!' message to the user. Gives them a button to create a new group.
///Button logic is not yet implemented, so it points them to the navbar element for creating a new group
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
