import 'package:firebase_auth/firebase_auth.dart';

class User {
  User({this.user, this.about});

  FirebaseUser user;
  String about;

  FirebaseUser getUser() => user;

  String getAbout() => about ?? "";

}

