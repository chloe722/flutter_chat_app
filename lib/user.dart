import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  User({this.user, this.about});

  FirebaseUser user;
  String about;

  FirebaseUser getUser() => user;

  String getAbout() => about ?? "";

//  void saveToDb() async {
//    //Update data to server if new user
//    Firestore.instance.collection('users').document(user.uid).setData({
//      'name': user.displayName,
//      'photoUrl': user.photoUrl,
//      'id': user.uid,
//      'about': getAbout(),
//    });
//  }
}

Future<void> updateProfileData({FirebaseUser user, String name}) async {
  await Firestore.instance.collection('users').document(user.uid).updateData({
    'name': name,
  });
}

void updateUserFromFirebaseUser(FirebaseUser user) async {
  //Update data to server if new user
  if (user != null) {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: user.uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      Firestore.instance.collection('users').document(user.uid).setData({
        'id': user.uid,
        'name': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
      });
    }
  }
}
