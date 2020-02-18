import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/strings.dart';
import 'package:flash_chat/widgets/input_section.dart';
import 'package:flash_chat/widgets/round_button.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({this.user, this.name,this.userName, this.phone,
      this.about});

  final FirebaseUser user;
  final String name;
  final String userName;
  final String phone;
  final String about;

  String _name;
  String _userName;
  String _phone;
  String _about;


  void save(BuildContext context, ) {
    updateProfileData(user: user, name: _name, phone: _phone, userName: _userName, about: _about, )
        .then((e) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SettingInputSection(
              content: name,
              iconData: Icons.edit,
              onChange: (value) => _name = value,
            ),
            SizedBox(
              height: 8.0,
            ),
            SettingInputSection(
            content: phone ,
              iconData: Icons.phone,
              onChange: (value) => _phone = value,
          ),
            SettingInputSection(
              content: userName ,
              iconData: Icons.alternate_email,
              onChange: (value) => _userName = value,
            ),
            SettingInputSection(
              content: about ,
              iconData: Icons.info,
              onChange: (value) => _about= value,
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundButton(
                color: Colors.blueAccent,
                label: kSave,
                onPressed: () => save(context))
          ],
        ),
      ),
    ));
  }

}
