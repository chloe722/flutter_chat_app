import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/settting/about_edit_screen.dart';
import 'package:flash_chat/screens/settting/phone_edit_screen.dart';
import 'package:flash_chat/screens/settting/status_edit_screen.dart';
import 'package:flash_chat/screens/settting/username_edit_screen.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  InfoCard({this.user, this.userName, this.email, this.phone, this.about, this.status, this.logOutCallback});

  //TODO update with User object
  final FirebaseUser user;
  final String userName;
  final String email;
  final String phone;
  final String about;
  final String status;
  final VoidCallback logOutCallback;


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5.0,
      child: Container(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.face),
              title: Text(status??'Tell people how you doing :)'),

              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: false,
                  builder: (context) => StatusEditScreen(
                    user: user,
                    status: status,
                  ))),
            ),
            ListTile(
              leading: Icon(Icons.alternate_email),
              title: Text(userName ?? 'Add Username'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UsernameEditScreen(
                    user: user,
                    username: userName,
                  ))),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(email),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(phone ?? 'Add Phone'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PhoneEditScreen(
                    user: user,
                    phone: phone,
                  ))),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(about ?? 'Write something :)'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  AboutEditScreen(
                    user: user,
                    about: about,
                  ))),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log out'),
              onTap: () => logOutCallback(),
            ),
          ],
        ),
      ),
    );
  }
}
