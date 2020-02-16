import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  FriendsScreen({this.user});

  final FirebaseUser user;

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  String frinedid =
      '0FPux2aAqEYx4hCDzPxZDzCy3wE3'; //TODO Updated with contact id or object

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addFriend(user: widget.user, friendId: frinedid),
          ),
        ],
      ),
      backgroundColor: kNavajowhite,
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Request', style: TextStyle(fontSize: 20.0)),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: getFriendRequest(widget.user).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(
                          child: Text('No friend request'),
                        ),
                      );
                    } else {
                      print('request list: ${snapshot.data.documents}');

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) => FriendRequestTile(
                          isFriend: Colors.grey,
                          friendId: snapshot.data.documents[index].documentID,
                          user: widget.user,
                        ),
                      );
                    }
                  }),
            ),
            Text('Friends', style: TextStyle(fontSize: 20.0)),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: getFriendList(widget.user).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(child: Text('No friend yet')),
                      );
                    } else {
                      print(" frined list: ${snapshot.data.documents}");
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) =>
                            FriendTile(isFriend: Colors.greenAccent[100]),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendRequestTile extends StatelessWidget {
  FriendRequestTile({this.snapshot, this.user, this.isFriend, this.friendId});

  final DocumentSnapshot snapshot;
  final FirebaseUser user;
  final Color isFriend;
  final String friendId;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
        color: isFriend,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          isThreeLine: true,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () =>
                    rejectFriendRequest(user: user, friendId: friendId),
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () => confirmFiend(user: user, friendId: friendId),
              ),
            ],
          ),
          leading: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://www.petsworld.in/blog/wp-content/uploads/2014/09/cat.jpg"),
                  fit: BoxFit.contain,
                ),
                shape: BoxShape.circle),
          ),
          title: Text(
            'Ski',
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 14.0),
          ),
          subtitle: Text('Love computer', style: TextStyle(color: Colors.grey)),
        ));
  }
}

class FriendTile extends StatelessWidget {
  FriendTile({this.snapshot, this.user, this.isFriend, this.friendId});

  final DocumentSnapshot snapshot;
  final FirebaseUser user;
  final Color isFriend;
  final String friendId;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
        color: isFriend,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          isThreeLine: true,
          trailing: Icon(Icons.person),
          leading: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://www.petsworld.in/blog/wp-content/uploads/2014/09/cat.jpg"),
                  fit: BoxFit.contain,
                ),
                shape: BoxShape.circle),
          ),
          title: Text(
            'Ski',
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 14.0),
          ),
          subtitle: Text('Love computer', style: TextStyle(color: Colors.grey)),
        ));
  }
}
