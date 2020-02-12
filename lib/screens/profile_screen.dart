import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../user.dart';

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
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('users').document(user.uid).snapshots(),
          builder: (context, snapshot) {
            Map data = snapshot.data?.data ?? Map();
            switch(snapshot.connectionState) {
              case ConnectionState.waiting: return Text("Loading..");
              default:
            return snapshot.hasData && snapshot.data != null? Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  Image.asset(snapshot.data.data["photoUrl"]!= null? user.getUser().photoUrl : "",
//                      fit: BoxFit.fill, height: 100, width: 100),
                  Text(data["name"]?? ""),
                  Text(data["email"]?? ""),
//                  Text(user.getAbout()),
                  RaisedButton(
                    child: Text('Log out'),
                    onPressed: () => logOutCallback(),
                  )
                ],
              ),
            ) : CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }
}
