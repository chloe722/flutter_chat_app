import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/auth.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/screens/home_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/user.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootScreen extends StatefulWidget {
  final Auth auth;

  RootScreen({this.auth});

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  FirebaseUser _user;


  void loginCallback() {
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _user = user;
        updateUserFromFirebaseUser(user);
      });
    });

    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }


  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _user = null;
    });
  }


  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {

      setState(() {
        if (user != null) {
          _user = user;
        }
        authStatus = user == null? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    switch(authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return CircularProgressIndicator();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return WelcomeScreen(auth: widget.auth, logInCallback: loginCallback,);
        break;

      case AuthStatus.LOGGED_IN:
        if (_user != null  && _user.uid != null && _user.uid.length> 0) {
          return HomeScreen(user: _user, logOutCallback: logoutCallback);
        } else {
          return CircularProgressIndicator();
        }
        break;
      default:
        return CircularProgressIndicator();

    }
  }
}
