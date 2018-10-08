import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  final Color _color;
  final String _text;

  PlaceholderWidget(this._color, this._text);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
      child: Center(child: Text(_text)),
    );
  }
}
