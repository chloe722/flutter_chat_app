import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/image_manager.dart';
import 'package:flash_chat/strings.dart';
import 'package:flash_chat/widgets/profile_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'settting/name_edit_screen.dart';

//TODO refactor
class ProfileScreen extends StatelessWidget {
  static String id = 'profile_screen';

  ProfileScreen({this.user, this.logOutCallback});

  final FirebaseUser user;
  final VoidCallback logOutCallback;

  void logout() {
    logOutCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSalmon,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        primary: true,
        child: StreamBuilder<DocumentSnapshot>(
            stream: getUserProfileById(user),
            builder: (context, snapshot) {
              Map data = snapshot.data?.data ?? Map();
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text("Loading..");
                default:
                  return snapshot.hasData && snapshot.data != null
                      ? Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: ProfileCard(user: user, userData: data),
                              ),
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
    );
  }
}

class ProfileCard extends StatefulWidget {
  ProfileCard({this.user, this.userData});

  final FirebaseUser user;
  final Map userData;

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  void _updateProfileImage() async {
    var _url = await getImage(ImageType.PROFILE);
    updateProfileData(user: widget.user, photoUrl: _url);
  }

  @override
  Widget build(BuildContext context) {

    double _cardHeight = 170;
    double _cardWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50.0),
          child: Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              width: _cardWidth,
              height: _cardHeight,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => _updateProfileImage(),
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(50.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: widget.userData["photoUrl"] == null ||
                              widget.userData["photoUrl"] == ""
                          ? AssetImage(kPlaceholderImage)
                          : CachedNetworkImageProvider(
                        "https://s.itl.cat/pngfile/s/213-2138222_20-girl-image-2019-new-fb-profile-pic.jpg",
                            ),
                    )),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NameEditScreen(
                      user: widget.user,
                      name: widget.userData["name"] ?? "",
                    ))),
                child: Text(
                  widget.userData["name"] ?? "Add Name",
                  style: TextStyle(
                      fontSize: 25.0,
                      color: kGreyBlack,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),


            ButtonsGroup(),

          ],
        ),
      ],
    );
  }
}

class ButtonsGroup extends StatelessWidget {
  Widget _actionButton({IconData icon, Function onPress}) {
    return MaterialButton(
      elevation: 8.0,
      padding: EdgeInsets.all(16.0),
      shape: CircleBorder(side: BorderSide.none),
      color: kBlurBlueGreen,
      onPressed: () => onPress,
      child: Icon(
        icon,
        size: 24.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: _actionButton(icon: Icons.message, onPress: () {}),
        ),
        _actionButton(icon: Icons.call, onPress: () {})
      ],
    );
  }
}
