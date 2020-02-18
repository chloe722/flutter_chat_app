import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/screens/settting/phone_edit_screen.dart';
import 'package:flash_chat/screens/settting/username_edit_screen.dart';
import 'package:flash_chat/screens/settting/setting_screen.dart';
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

  void logout() {
    logOutCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                              Stack(children: <Widget>[
                                Container(
//                                    margin: EdgeInsets.symmetric(vertical: 16.0),
                                  height: 230,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
//                                        borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: data["photoUrl"] ??
                                        "https://imglarger.com/Images/hd-image-sample.jpg",
                                    placeholder: (context, url) => Icon(
                                      Icons.person,
                                      size: 50,
                                    ),
//                                      color: Colors.grey[300],
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 150,
                                  child: GestureDetector(
                                    onTap: () => showModalBottomSheet(
                                      isDismissible: true,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) =>
                                            AnimatedPadding(
                                              padding: MediaQuery.of(context).viewInsets,  //边距（必要）
                                              duration: const Duration(milliseconds: 100), //时常 （必要// Added to fix the problem of textinput got covered by keyboard
                                              child: BottomSheetWidget(user: user,name: data["name"]??"",),
                                            )),
                                    child: Text(
                                      data["name"]?? "",
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ]),
                              InfoCard(
                                user: user,
                                email: data["email"] ?? "",
                                userName: data["userName"],
                                phone: data["phone"],
                                about: data["about"],
                              ),
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

class InfoCard extends StatelessWidget {
  InfoCard({this.user, this.userName, this.email, this.phone, this.about});

  final FirebaseUser user;
  final String userName;
  final String email;
  final String phone;
  final String about;

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
              title: Text('Tell people how you doing :)'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: false,
                  builder: (context) => SettingScreen(
                        user: user,
                      ))),
            ),
            ListTile(
              leading: Icon(Icons.alternate_email),
              title: Text(userName ?? 'Add Username'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditUsernameScreen(
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
                  MaterialPageRoute(builder: (context) => EditPhoneScreen(
                    user: user,
                    phone: phone,
                  ))),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(about ?? 'Write something :)'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
//TODO fix the problem of cursor reset at 0
class BottomSheetWidget extends StatefulWidget {
  final FirebaseUser user;
  final String name;


  BottomSheetWidget({this.user, this.name});

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  TextEditingController nameController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  void _save(BuildContext context) {
    String _name = nameController.value.text;
    print('name: $_name');

    if (_name != null) {
      updateProfileData(user: widget.user, name: _name)
          .then((e) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final val = TextSelection.collapsed(offset: nameController.text.length);
    nameController.selection = val;
    return Container(
      color: kDodgerBlue,
      height: 150,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedTextField(controller: nameController, name: widget.name),
            RaisedButton(
              color: Colors.white,
              child: Text('Save'),
              onPressed: () => _save(context),
            )

          ]),
    );
  }
}

class DecoratedTextField extends StatelessWidget {
  DecoratedTextField({this.name, this.controller});

  final String name;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: controller,
          onChanged: (val) {
            controller.value = TextEditingController.fromValue(TextEditingValue(text: val)).value;
          },
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: name,

          ),
        ));
  }
}
