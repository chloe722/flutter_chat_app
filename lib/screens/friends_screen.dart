import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatelessWidget {
  FriendsScreen({this.user});

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Center(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {

                return Center(
                  child: CircularProgressIndicator(),
                );

              } else {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => FriendTile(snapshot: snapshot.data.documents[index],),
                );
              }
            }
          ),
        ),
      ),
    );
  }
}


class FriendTile extends StatelessWidget {
  FriendTile({this.snapshot});

  final DocumentSnapshot snapshot;



  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen())),
        isThreeLine: true,
        trailing: Icon(Icons.person),
        leading: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://www.petsworld.in/blog/wp-content/uploads/2014/09/cat.jpg"),
                fit: BoxFit.contain,
              ),
              shape: BoxShape.circle
            ),
          ),
        title: Text('Ski', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold, fontSize: 14.0),),
        subtitle: Text('Love computer', style: TextStyle(color: Colors.grey)),
      )
    );
  }
}
