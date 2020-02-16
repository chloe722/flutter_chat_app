import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/setting_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static String id = 'profile_screen';

  ProfileScreen({this.user, this.logOutCallback});

  final FirebaseUser user;
  final VoidCallback logOutCallback;

  void setting(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SettingScreen(
                  user: user,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.settings),
//            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(user: user,))),
//          )
//        ],
//      ),
      body: Container(
        color: kDodgerBlue,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 16.0),
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: data["photoUrl"] ?? "",
                                  placeholder: (context, url) => Icon(
                                    Icons.person,
                                    size: 50,
                                  ),
                                  color: Colors.grey[300],
                                  fit: BoxFit.fill,
                                  height: 100,
                                  width: 100,
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  data["name"] ?? "",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
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
