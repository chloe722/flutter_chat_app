import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/widgets/info_editing_card.dart';
import 'package:flutter/material.dart';

class UsernameEditScreen extends StatelessWidget {
  UsernameEditScreen({this.user, this.username});

  final FirebaseUser user;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Username', style: kAppBarTextStyle),
          centerTitle: true,
          iconTheme: IconThemeData(color: kBrown),
        ),
        body: Container(
          color: kDodgerBlue,
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: InfoEditingCard(
                content: username,
                icon: Icons.alternate_email,
                onTap: (String usernameVal) =>
                    updateProfileData(user: user, userName: usernameVal)
                        .then((e) => Navigator.pop(context))),
          ),
        ));
  }
}
