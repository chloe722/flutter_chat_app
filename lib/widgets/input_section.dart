import 'package:flutter/material.dart';

import '../constants.dart';

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
      decoration: kTextFieldDecoration.copyWith(hintText: hint)
    );
  }
}
