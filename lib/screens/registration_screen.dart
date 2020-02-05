import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/auth.dart';
import 'package:flash_chat/strings.dart';
import 'package:flash_chat/widgets/input_section.dart';
import 'package:flash_chat/widgets/round_button.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registeration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: kLogoTag,
              child: Container(
                height: 200.0,
                child: Image.asset(kLogoImage),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            InputSection(
              hint: kEnterEmailHint,
              color: Colors.blueAccent,
              onChange: (value) {
                print('email: ' + value);
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            InputSection(
              hint: kEnterPwdHint,
              color: Colors.blueAccent,
              obscureText: true,
              onChange: (value) {
                print('pwd: ' + value);
              },
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundButton(
                color: Colors.blueAccent,
                label: kRegister,
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
