import 'package:flutter/material.dart';

class InputSection extends StatelessWidget {
  final String hint;
  final Function onChange;
  final bool obscureText;
  final Color color;

  InputSection(
      {this.hint, this.onChange, this.obscureText = false, this.color});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChange,
      obscureText: obscureText,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[900]),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.grey),
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
