import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {

  PlaceholderWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("This feature has been temporarily discontinued.")),
    );
  }
}
