import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/model/avaliable_users.dart';
import 'package:flash_chat/model/user.dart';
import 'package:flash_chat/strings.dart';
import 'package:flutter/material.dart';

class AddFriendScreen extends StatelessWidget {
  AddFriendScreen({this.user});

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: StreamBuilder<List<AvailableUsers>>(
          stream: getAvailableUsersList(user: user),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              CircularProgressIndicator();
            if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) =>
                    AddFriendTile(user: user, friend: data[i]),
                shrinkWrap: true,
              );
            } else {
              return Center(child: Text("No users join at the moment"));
            }
          }),
    ));
  }
}

class AddFriendTile extends StatelessWidget {
  AddFriendTile({this.friend, this.user});

  final AvailableUsers friend;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          onTap: () {print('open profile');},
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          trailing: IconButton(
              icon: friend.requestSent? Icon(Icons.send, color: Colors.amber) : Icon(Icons.person_add, color: Colors.green),
              onPressed: friend.requestSent? null : () => addFriend(user: user, friendId: friend.user.id)),
          leading: CircleAvatar(
          backgroundImage: friend.user.photoUrl.isEmpty
                        ? AssetImage(kPlaceholderImage)
                        : CachedNetworkImageProvider(friend.user.photoUrl),
          ),

          title: Text(
            friend.user.name,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 14.0),
          ),
          subtitle: Text(friend.user.status, style: TextStyle(color: Colors.grey)),
        ));
  }
}
