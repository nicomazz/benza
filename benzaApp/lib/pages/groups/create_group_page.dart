import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

import 'package:benza/services/gmaps.dart';
import 'package:benza/resources/group_provider.dart';
import 'package:benza/models/Group.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateRequestPageState createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateGroupPage> {
  int _currentStep = 0;
  String _startQuery = "";
  Coordinates _startCoord;
  String _endQuery = "";
  Coordinates _endCoord;
  Group newGroup = new Group();
  DocumentSnapshot groupCreator;

  ///Populates the _CreateRequestPageState's [groupCreator] variable with the firestore data relating to the current user.
  updateUser() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    groupCreator = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    //Updating the current user
    updateUser();
    //Creating a map of that user's firestore data
    var data = groupCreator?.data ?? Map();
    //Extracting the user's uid
    var uid = data["uid"].toString();
    //Creating a list with a single uid inside
    List<String> uidList = [uid];
    var random = new Random();

    return Scaffold(
      body: Stepper(
        steps: _mySteps(),
        currentStep: this._currentStep,
        //Go back a step, unless you're on step 0 (in which case do nothing)
        onStepCancel: () {
          if (this._currentStep - 1 >= 0)
            setState(() {
              _currentStep -= 1;
            });
        },
        onStepContinue: () {
          //If step 0, get the proper address for the given start location
          if (this._currentStep == 0) {
            setState(() {
              this.newGroup.name = _startQuery;
              this._currentStep += 1;
            });
            //If step 1, get the proper address for the given destination location
          } else if (this._currentStep == 1) {
            _fetchCorrectPosition(this._endQuery, (addr) {
              setState(() {
                this._currentStep += 1;
                //Adding information to the group object that we are going to post soon
                this.newGroup.location = addr.locality;
                this.newGroup.group_id = random.nextInt(999);
                this.newGroup.users = uidList;
                this.newGroup.coords = getCoords(addr.coordinates);
                this._endQuery = addr.addressLine;
              });
            });
            //If next step is less than 3 (the final step), increment the current step
          } else if (this._currentStep + 1 <= 3) {
            setState(() {
              this._currentStep += 1;
            });
            //If you have tapped continue on the final step
          } else if (this._currentStep <= 4) {
            print("\nTrying to POST: ${this.newGroup.toJson()}\n");
            setState(() {
              //Initiate the point of contact with the group_provider.dart file
              var apiProvider = new GroupDataProvider();
              //Use the client method in group_provider.dart to create a new group
              apiProvider.postGroup(this.newGroup.toJson());
            });
            //If there's no errors, show a success message
            Scaffold.of(context).showSnackBar(new SnackBar(
                content: Text("Created your group successfully!")));
          }
        },
      ),
    );
  }

  ///Workaround: formats a pair of doubles as a single string, so they play nice with the API
  String getCoords(Coordinates initialCoords) {
    String str = initialCoords.latitude.toString() +
        ", " +
        initialCoords.longitude.toString();
    return str;
  }

  ///Returns the most 'relevant' location data, when given a query that contains actual location data
  _fetchCorrectPosition(String query, Function(Address) then) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (query.isEmpty) return;
    print("\n------------ Geocoder fetch initiated ------------\n");
    //Use geocoder's method to lookup address shortlist
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    if (addresses.isEmpty) {
      print("No addresses found");
      return;
    }
    //Geocoder returns the most relevant address at the start of the list, so we bet on that one being the address we want.
    //If it is the wrong address, users will hopefully notice when they see the location on the map preview. From here,
    //they can go back a step and add more information to further specify the location they want.
    var first = addresses.first;
    print(
        "Address: ${first.addressLine} at ${first.coordinates}\n- Locality: ${first.locality}\n- Sublocality: ${first.subLocality}\n- adminArea: ${first.adminArea}\n- subAdminArea: ${first.subAdminArea}\n- Thoroughfare: ${first.thoroughfare}\n- Subthoroughfare: ${first.subThoroughfare}\n");
    then(first);
  }

  ///The list of steps that are visible to users in the create_group_page.dart file.
  List<Step> _mySteps() => [
        Step(
            title: _currentStep == 0 ? Text("") : Text("${this._startQuery}"),
            content: TextField(
                autofocus: true,
                decoration: InputDecoration(hintText: "Your group's name"),
                onChanged: (text) {
                  this.setState(() {
                    _startQuery = text;
                  });
                }),
            isActive: _currentStep >= 0),
        Step(
            title: _currentStep == 1 ? Text("") : Text("${this._endQuery}"),
            content: TextField(
                autofocus: true,
                decoration: InputDecoration(hintText: "Your group's location"),
                onChanged: (text) {
                  this.setState(() {
                    _endQuery = text;
                  });
                }),
            isActive: _currentStep >= 1),
        Step(
            title: _currentStep == 2 ? Text("Does this look right?") : Text(""),
            content: SizedBox(
              height: 250.0,
              child: _currentStep >= 2
                  ? MapsDemo(coords: this.newGroup.coords)
                  : Text(""),
            ),
            isActive: _currentStep >= 2),
        Step(
            title: _currentStep == 3 ? Text("Confirm group") : Text(""),
            content: Text(""),
            isActive: _currentStep >= 3)
      ];
}
