import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/model/user.dart';
import 'package:flash_chat/utils.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class FriendsScreen extends StatefulWidget {
  FriendsScreen({this.user});

  final FirebaseUser user;

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDodgerBlue,
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Request', style: TextStyle(fontSize: 20.0)),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              child: StreamBuilder<List<User>>(
                  stream: getFriendRequest(widget.user),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      var data = snapshot.data;

                      if (data.isEmpty) {
                        return Text('No request');
                      } else {
                        print('request list: $data');
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, i) => FriendRequestTile(
                            friendRequest: data[i],
                            user: widget.user,
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: Container(
                          child: Text('No friend request'),
                        ),
                      );
                    }
                  }),
            ),
            Text('Friends', style: TextStyle(fontSize: 20.0)),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              child: StreamBuilder<List<User>>(
                  stream: getFriendList(widget.user),
                  builder: (context, snapshot) {
                    if (snapshot.hasData != null && snapshot.data != null) {
                      var data = snapshot.data;
                      print(" frined list: $data");

                      if (data.isEmpty) {
                        return Text('No freinds yet');
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, i) => FriendTile(
                              user: widget.user,
                              friend: data[i],
                              isFriend: Colors.greenAccent[100]),
                        );
                      }
                    } else {
                      return Center(
                        child: Container(child: Text('No friend yet')),
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
  FriendRequestTile({this.friendRequest, this.user});

  final User friendRequest;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
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
                    rejectFriendRequest(user: user, friendId: friendRequest.id),
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () =>
                    confirmFriend(user: user, friend: friendRequest),
              ),
            ],
          ),
          leading: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(friendRequest.photoUrl??""),
                  fit: BoxFit.contain,
                ),
                shape: BoxShape.circle),
          ),
          title: Text(
            friendRequest.name,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 14.0),
          ),
          subtitle:
              Text(friendRequest.status, style: TextStyle(color: Colors.grey)),
        ));
  }
}

class FriendTile extends StatelessWidget {
  FriendTile({this.friend, this.user, this.isFriend});

  final User friend;
  final FirebaseUser user;
  final Color isFriend;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          onTap: () async {
            String _chatId = await getChatId(user: user, friendId: friend.id);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        user: user, friendId: friend.id, chatId: _chatId)));
          },
          isThreeLine: true,
          leading: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(friend.photoUrl),
                  fit: BoxFit.contain,
                ),
                shape: BoxShape.circle),
          ),
          title: Text(
            friend.name,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 14.0),
          ),
          subtitle: Text(friend.status, style: TextStyle(color: Colors.grey)),
        ));
  }
}
