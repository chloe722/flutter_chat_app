import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Color color;
  final Function onPressed;
  final String label;

  RoundButton({this.color, this.onPressed, this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(30.0),
      elevation: 5.0,
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: 200.0,
        height: 42.0,
        child: Text(
          label,
        ),
      ),
    );
  }
}
