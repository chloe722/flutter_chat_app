import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static String id = 'profile_screen';

  ProfileScreen({this.user, this.logOutCallback});

  final FirebaseUser user;
  final VoidCallback logOutCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
//              Image.asset(user.photoUrl != null? user.photoUrl : "", fit: BoxFit.fill, height: 100, width: 100),
              Text(user.displayName != null? user.displayName : ""),
              Text(user.email),
              RaisedButton(
                child: Text('Log out'),
                onPressed: () => logOutCallback(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
