import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/setting_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static String id = 'profile_screen';

  ProfileScreen({this.user, this.logOutCallback});

  final FirebaseUser user;
  final VoidCallback logOutCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(user: user,))),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('users')
                .document(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              Map data = snapshot.data?.data ?? Map();
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text("Loading..");
                default:
                  return snapshot.hasData && snapshot.data != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(data["photoUrl"] ?? "",
                                  fit: BoxFit.fill, height: 100, width: 100),
                              Text(data["name"] ?? ""),
                              Text(data["email"] ?? ""),
//                  Text(user.getAbout()),
                              RaisedButton(
                                child: Text('Log out'),
                                onPressed: () => logOutCallback(),
                              )
                            ],
                          ),
                        )
                      : CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
