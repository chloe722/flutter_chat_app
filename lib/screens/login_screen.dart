import 'package:flash_chat/screens/strings.dart';
import 'package:flash_chat/widgets/input_section.dart';
import 'package:flash_chat/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              color: Colors.lightBlueAccent,
              onChange: (value) {
                print('email: ' + value);
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            InputSection(
              hint: kEnterPwdHint,
              color: Colors.lightBlueAccent,
              obscureText: true,
              onChange: (value) {
                print('pwd: ' + value);
              },
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RoundButton(
                  color: Colors.lightBlueAccent,
                  label: kLogin,
                  onPressed: () => print('add later')),
            ),
          ],
        ),
      ),
    );
  }
}
