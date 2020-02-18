import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/strings.dart';
import 'package:flash_chat/widgets/round_button.dart';
import 'package:flutter/material.dart';

class EditUsernameScreen extends StatelessWidget {
  EditUsernameScreen({this.user, this.userName});

  TextEditingController _controller;

  final FirebaseUser user;
  final String userName;

  String _userName;

  void save(BuildContext context) {
    updateProfileData(user: user, userName: _userName)
        .then((e) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController(text: userName);
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
            child: Card(
              elevation: 8.0,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    child: TextFormField(
                      controller: _controller,
                      maxLines: 1,
                      onChanged: (value) => _userName = value,
                      decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.0, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(8.0)),
                          fillColor: Colors.grey[300]),
                    ),
                  ),
                  RoundButton(
                      color: Colors.white,
                      label: kSave,
                      onPressed: () => save(context))
                ],
              ),
            ),
          ),
        ));
  }
}
