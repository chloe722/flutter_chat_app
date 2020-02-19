import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String userName;
  String name;
  String photoUrl;
  String email;
  String phone;

  User({this.id, this.userName, this.name, this.photoUrl, this.email, this.phone});


  factory User.fromFirebase(DocumentSnapshot snapshot){
    return User(
      id: snapshot.documentID,
      name: snapshot.data["name"],
      userName: snapshot.data["userName"],
      phone: snapshot.data["phone"],
      photoUrl: snapshot.data["photoUrl"],
      email: snapshot.data["email"],
    );
  }

}