import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/auth.dart';
import 'package:flash_chat/screens/profile_screen.dart';
import 'package:flash_chat/strings.dart';
import 'package:flash_chat/widgets/input_section.dart';
import 'package:flash_chat/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  LoginScreen({this.auth, this.logInCallback});

  final BaseAuth auth;
  final VoidCallback logInCallback;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _errorMsg = "";
  bool _isLoading = true;
  FirebaseUser _user;
  String email = "";
  String password = "";

  void validateAndSubmit() async {
    setState(() {
      _errorMsg = "";
      _isLoading = true;
    });

    try {
      _user = await widget.auth.logIn(email: email, password: password);
      setState(() {
        _isLoading = false;
      });

      if (_user != null && _user.uid != null && _user.uid.length > 0) {
        widget.logInCallback();
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        _errorMsg = e.toString();
      });
    }
  }

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
            Flexible(
              child: Hero(
                tag: kLogoTag,
                child: Container(
                  height: 200.0,
                  child: Image.asset(kLogoImage),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            InputSection(
              hint: kEnterEmailHint,
              color: Colors.lightBlueAccent,
              onChange: (value) {
                email = value;
                print('email: ' + email);
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
                password = value;
                print('pwd: ' + password);
              },
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundButton(
                color: Colors.lightBlueAccent,
                label: kLogin,
                onPressed: () => validateAndSubmit()),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('or', style: TextStyle(color: Colors.grey)),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            RoundButton(
                color: Colors.deepOrangeAccent,
                label: kGoogleLogin,
                onPressed: () =>
                    widget.auth.googleLogIn().then((FirebaseUser user) {
                      print(user);
                      Navigator.pushNamed(context, ProfileScreen.id,
                          arguments: user);
                    }).catchError((e) => print(e))),
          ],
        ),
      ),
    );
  }
}
