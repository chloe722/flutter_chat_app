//TODO fix the problem of cursor reset at 0
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flutter/material.dart';

import 'decorated_text_field.dart';

class BottomSheetWidget extends StatefulWidget {
  final FirebaseUser user;
  final String name;


  BottomSheetWidget({this.user, this.name});

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  TextEditingController nameController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  void _save(BuildContext context) {
    String _name = nameController.value.text;
    print('name: $_name');

    if (_name != null) {
      updateProfileData(user: widget.user, name: _name)
          .then((e) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final val = TextSelection.collapsed(offset: nameController.text.length);
    nameController.selection = val;
    return Container(
      color: kDodgerBlue,
      height: 150,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedTextField(controller: nameController, name: widget.name),
            RaisedButton(
              color: Colors.white,
              child: Text('Save'),
              onPressed: () => _save(context),
            )

          ]),
    );
  }
}

