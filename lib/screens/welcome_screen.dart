import 'package:flash_chat/auth.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/strings.dart';
import 'package:flash_chat/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

enum AuthState {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  WelcomeScreen({this.auth, this.logInCallback});

  final BaseAuth auth;
  final VoidCallback logInCallback;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation =
        ColorTween(begin: Colors.red, end: Colors.white).animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: kLogoTag,
                  child: Container(
                    child: Image.asset(kLogoImage),
                    height: 60,
                  ),
                ),
                ColorizeAnimatedTextKit(
                  text: [kFlashChat],
                  textStyle:
                      TextStyle(fontSize: 50.0, fontWeight: FontWeight.w900),
                  colors: [
                    Colors.deepOrangeAccent,
                    Colors.blue,
                    Colors.deepPurple
                  ],
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundButton(
                color: Colors.lightBlueAccent,
                label: kLogin,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(
                              auth: widget.auth,
                              logInCallback: widget.logInCallback,
                            )))),
            RoundButton(
                color: Colors.blueAccent,
                label: kRegister,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen(
                              auth: widget.auth,
                              logInCallback: widget.logInCallback,
                            )))),
          ],
        ),
      ),
    );
  }
}
