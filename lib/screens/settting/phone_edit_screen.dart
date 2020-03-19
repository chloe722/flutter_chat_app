import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/widgets/info_editing_card.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class PhoneEditScreen extends StatelessWidget {
  PhoneEditScreen({this.user, this.phone});

  final FirebaseUser user;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kSalmon,
        appBar: AppBar(
          backgroundColor: kSalmon,
          elevation: 0.0,
          title: Text('Phone', style: kAppBarTextStyle),
          centerTitle: true,
          iconTheme: IconThemeData(color: kBrown),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: InfoEditingCard(
                content: phone,
                icon: Icons.phone,
                onTap: (String phoneVal) =>
                    updateProfileData(user: user, phone: phoneVal)
                        .then((e) => Navigator.pop(context))),
          ),
        ));
  }
}
