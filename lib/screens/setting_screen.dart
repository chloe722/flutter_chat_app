import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/strings.dart';
import 'package:flash_chat/widgets/input_section.dart';
import 'package:flash_chat/widgets/round_button.dart';
import 'package:flutter/material.dart';

import '../user.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({this.user});

  final FirebaseUser user;
  String name;


  void save(BuildContext context) {
    updateProfileData(user: user, name: name).then((e) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child: Column(
        children: <Widget>[
          InputSection(
            hint: user.displayName,
            color: Colors.lightBlueAccent,
            onChange: (value) => name = value,
          ),
          SizedBox(
            height: 8.0,
          ),
//          InputSection(
//            hint: kEnterPwdHint,
//            color: Colors.lightBlueAccent,
//            obscureText: true,
//            onChange: (value) {
//            },
//          ),

          SizedBox(
            height: 24.0,
          ),
          RoundButton(
              color: Colors.blueAccent,
              label: kSave,
              onPressed: () => save(context))
        ],
      ),
    ));
  }
}
