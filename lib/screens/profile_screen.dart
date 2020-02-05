import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static String id = 'profile_screen';

  ProfileScreen({this.user});

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[

            Image.asset(user.photoUrl, fit: BoxFit.fill, height: 100, width: 100),
            Text(user.displayName),
            Text(user.email),
            RaisedButton(
              child: Text('Log out'),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
