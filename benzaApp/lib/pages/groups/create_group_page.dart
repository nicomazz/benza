import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong/latlong.dart';

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
	updateUser() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    groupCreator = await Firestore.instance.collection('users').document(currentUser.uid).get();
  }

	@override
	Widget build(BuildContext context) {
		updateUser();
		var data = groupCreator?.data ?? Map();
  	var uid = data["uid"].toString();
		List<String> uidList = [uid];

		return Scaffold(
			body: Stepper(
				steps: _mySteps(),
				currentStep: this._currentStep,
				// Go back a step, unless you're on step 0 (in which case do nothing)
				onStepCancel: () {
					if (this._currentStep - 1 >= 0)
						setState(() {
							_currentStep -= 1;
						});
				},
				onStepContinue: () {
					// If step 0, get the proper address for the given start location
					if (this._currentStep == 0) {
						setState(() {
							this.newGroup.name = _startQuery;
							this._currentStep += 1;
						});
						/*_fetchCorrectPosition(this._startQuery, (addr) {
							setState(() {
								this._currentStep += 1;
								this._startCoord = addr.coordinates;
								this._startQuery = addr.addressLine;
							});
						});*/
					// If step 1, get the proper address for the given destination location
					} else if (this._currentStep == 1) {
						_fetchCorrectPosition(this._endQuery, (addr) {
							setState(() {
								this._currentStep += 1;
								this.newGroup.location = addr.subAdminArea;
								this.newGroup.group_id = 9;
								this.newGroup.users = uidList;
								this._endCoord = addr.coordinates;
								this._endQuery = addr.addressLine;
							});
						});
					// If next step is less than 3 (the final step), increment the current step
					} else if (this._currentStep + 1 <= 3){
						setState(() {
							this._currentStep += 1;
						});
					} else if (this._currentStep <= 4){
						print("\nTrying to POST: ${this.newGroup.toJson()}\n");
						setState(() {
							// this is where we have to postGroup()!
							var apiProvider = new GroupDataProvider();
							apiProvider.postGroup(this.newGroup.toJson());
						});
					}
				},
			),
		);
	}

	_fetchCorrectPosition(String query, Function(Address) then) async {
		if (query.isEmpty) return;
		print("\n------------ Geocoder fetch initiated ------------\n");
		var addresses = await Geocoder.local.findAddressesFromQuery(query);
		if (addresses.isEmpty) {
			print("No addresses found");
			return;
		}
		var first = addresses.first;
		print("Address: ${first.addressLine} at ${first.coordinates}\n- Locality: ${first.locality}\n- Sublocality: ${first.subLocality}\n- adminArea: ${first.adminArea}\n- subAdminArea: ${first.subAdminArea}\n- Thoroughfare: ${first.thoroughfare}\n- Subthoroughfare: ${first.subThoroughfare}\n");
		then(first);
	}

	List<Step> _mySteps() => [
				Step(
						title: Text("Name: ${this._startQuery}"),
						content: TextField(onChanged: (text) {
							this.setState(() {
								_startQuery = text;
							});
						}),
						isActive: _currentStep >= 0),
				Step(
						title: Text("Location: ${this._endQuery}"),
						content: TextField(onChanged: (text) {
							this.setState(() {
								_endQuery = text;
							});
						}),
						isActive: _currentStep >= 1),
				Step(
						title: Text("Area"),
						content: SizedBox(
							height: 250.0,
							child: MapsDemo(),
						),
						isActive: _currentStep >= 2),
				Step(
						title: Text("Confirm"),
						content: SizedBox(),
						isActive: _currentStep >= 3)
			];

	getFromToCoords() {
		if (_startCoord != null && _endCoord != null) {
			return [
				LatLng(_startCoord.latitude, _startCoord.longitude),
				LatLng(_endCoord.latitude, _endCoord.longitude)
			];
		}
	}
}
