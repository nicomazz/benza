import 'package:benza/services/map_utilities.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong/latlong.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateRequestPageState createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateGroupPage> {
  int _currentStep = 0;
  String _startQuery = "";
  Coordinates _startCoord;
  String _endQuery = "";
  Coordinates _endCoord; // = "";

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(title: Text("Create request"), centerTitle: true);

    return Scaffold(
        appBar: appbar,
        body: Stepper(
          steps: _mySteps(),
          currentStep: this._currentStep,
          onStepCancel: (){
            if (this._currentStep-1 >= 0)
              setState((){
                _currentStep -= 1;
              });
          },
          onStepContinue: () {
            if (this._currentStep == 0) {
              _fetchCorrectPosition(this._startQuery, (addr) {
                setState(() {
                  this._currentStep += 1;
                  this._startCoord = addr.coordinates;
                  this._startQuery = addr.addressLine;
                });
              });
            } else if (this._currentStep == 1) {
              _fetchCorrectPosition(this._endQuery, (addr) {
                setState(() {
                  this._currentStep += 1;
                  this._endCoord = addr.coordinates;
                  this._endQuery = addr.addressLine;
                });
              });
            } else if (this._currentStep+1 < 3)
              setState((){ this._currentStep += 1;});
          },
        ));
  }

  _fetchCorrectPosition(String query, Function(Address) then) async {
    if (query.isEmpty) return;
    print("Fetch initiated");
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    if (addresses.isEmpty) {
      print("No addresses found");
      return;
    }
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
    then(first);
  }

  List<Step> _mySteps() =>
      [
        Step(
          title: Text("Starting point: ${this._startQuery}"),
          content: TextField(
            onChanged: (text) {
              this.setState(() {
                _startQuery = text;
              });
            },
          ),
          isActive: _currentStep >= 0,
        ),
        Step(
            title: Text("Ending point: ${this._endQuery}"),
            content: TextField(onChanged: (text) {
              this.setState(() {
                _endQuery = text;
              });
            }),
            isActive: _currentStep >= 1),
        Step(
            title: Text("Review path"),
            content: SizedBox(
              height: 250.0,
              child: MyMap(
                  points: getStartEndCoordArray(), name: "create_group_map"),
            ),
            isActive: _currentStep >= 2),
        Step(
            title: Text("Confirm"),
            content: TextField(),
            isActive: _currentStep >= 3)
      ];

  getStartEndCoordArray() {
    if (_startCoord != null && _endCoord != null) {
      return [
        LatLng(_startCoord.latitude, _startCoord.longitude),
        LatLng(_endCoord.latitude, _endCoord.longitude)
      ];
    }
  }
}
