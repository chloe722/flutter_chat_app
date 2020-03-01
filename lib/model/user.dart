import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String userName;
  String name;
  String photoUrl;
  String email;
  String phone;
  String about;
  String status;

  User({this.id, this.userName, this.name, this.photoUrl, this.email, this.phone, this.about, this.status });


  factory User.fromFirebase(DocumentSnapshot snapshot){
    return User(
      id: snapshot.documentID,
      name: snapshot.data["name"]??"",
      userName: snapshot.data["userName"],
      phone: snapshot.data["phone"]??"",
      photoUrl: snapshot.data["photoUrl"]??"",
      email: snapshot.data["email"],
      status: snapshot.data["status"]??"",
      about: snapshot.data["about"]??"",
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;


}