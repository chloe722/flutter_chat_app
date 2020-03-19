import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/widgets/info_editing_card.dart';
import 'package:flutter/material.dart';

class NameEditScreen extends StatelessWidget {
  NameEditScreen({this.user, this.name});

  final FirebaseUser user;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kSalmon,
        appBar: AppBar(
          backgroundColor: kSalmon,
          elevation: 0.0,
          title: Text('Name', style: kAppBarTextStyle),
          centerTitle: true,
          iconTheme: IconThemeData(color: kBrown),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: InfoEditingCard(
                content: name,
                icon: Icons.edit,
                onTap: (String nameVal) =>
                    updateProfileData(user: user, name: nameVal)
                        .then((e) => Navigator.pop(context))),
          ),
        ));
  }
}
