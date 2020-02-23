import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/image_manager.dart';
import 'package:flash_chat/widgets/profile_info_card.dart';
import 'package:flutter/material.dart';

import 'settting/name_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  static String id = 'profile_screen';

  ProfileScreen({this.user, this.logOutCallback});

  final FirebaseUser user;
  final VoidCallback logOutCallback;

  void _updateProfileImage() async {
    var _url = await getImage(ImageType.PROFILE);
    updateProfileData(user: user,photoUrl: _url);
  }

  void logout() {
    logOutCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        primary: true,
        child: Container(
          color: kDodgerBlue,
          child: StreamBuilder<DocumentSnapshot>(
              stream: getUserProfileById(user),
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
                                  GestureDetector(
                                    onTap: () => _updateProfileImage(),
                                    child: Container(
//                                    margin: EdgeInsets.symmetric(vertical: 16.0),
                                      height: 230,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
//                                        borderRadius: BorderRadius.circular(100.0),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: data["photoUrl"] ??
                                            "https://imglarger.com/Images/hd-image-sample.jpg",
                                        placeholder: (context, url) => Container(
                                            height: 100.0,
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Center(child: CircularProgressIndicator())),
                                        errorWidget: (context, url, error) => Material(
                                          child: Text('Image is not available'),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 150,
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => NameEditScreen(
                                        user: user,
                                        name: data["name"]??"",
                                      ))),
//                                        showModalBottomSheet(
//                                      isDismissible: true,
//                                        isScrollControlled: true,
//                                        context: context,
//                                            AnimatedPadding(
//                                              padding: MediaQuery.of(context).viewInsets,
//                                              duration: const Duration(milliseconds: 100),Added to fix the problem of textinput got covered by keyboard
//                                              child: BottomSheetWidget(user: user,name: data["name"]??"",),
//                                            )),
                                      child: Text(
                                        data["name"]?? "Add Name",
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
                                  status: data["status"],
                                  logOutCallback: logOutCallback,
                                ),
                              ],
                            ),
                          )
                        : CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}
