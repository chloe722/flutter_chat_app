import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/database.dart';
import 'package:flutter/material.dart';

class AddFriendScreen extends StatelessWidget {
  AddFriendScreen({this.user});

  final FirebaseUser user;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: getNewUsersList().snapshots(),
            builder: (context, snapshot) {
              var data = snapshot.data?.documents;

              if (snapshot.connectionState == ConnectionState.waiting)CircularProgressIndicator();
              if (data != null) {
                return ListView.builder(
                  itemCount: data.length,
                    itemBuilder: (context, i) => AddFriendTile(user: user, snapshot: data[i]),shrinkWrap: true,);
              } else {

                return Text("No users join at the moment");
              }
            }
          ),

    ));
  }
}

class AddFriendTile extends StatelessWidget {
  AddFriendTile({this.snapshot, this.user});

  final DocumentSnapshot snapshot;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          trailing: IconButton(icon: Icon(Icons.person_add), onPressed: () => addFriend(user: user, friendId: snapshot.data["id"])),
          leading: Container(
            width: 80.0,
            height: 100.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.center,
                  fit: BoxFit.cover,
                image: CachedNetworkImageProvider(snapshot.data["photoUrl"]??"")
              ),
                shape: BoxShape.circle),
            ),

          title: Text(
            snapshot.data["name"],
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 14.0),
          ),
//          subtitle: Text("Love computer", style: TextStyle(color: Colors.grey)),
        ));
  }
}
