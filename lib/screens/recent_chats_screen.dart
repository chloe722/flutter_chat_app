import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/model/recent_chat.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/strings.dart';
import 'package:flutter/material.dart';

class RecentChatsScreen extends StatelessWidget {
  RecentChatsScreen({this.user});

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSalmon,
      body: Center(
        child: Container(
          child: StreamBuilder<List<RecentChat>>(
              stream: getRecentChats(user: user),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();

                if (!snapshot.hasData ) {
                  return Center(
                    child:  CircularProgressIndicator(),
                  );
                } else {
                  final _data = snapshot.data;
                  if (_data.isEmpty) return Center(child: Text(" No chats yet"));
                  return ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, i) => RecentChatTile(
                        recentChat: _data[i], user: user),
                  );
                }
              }),
        ),
      ),
    );
  }
}

class RecentChatTile extends StatelessWidget {
  RecentChatTile({this.recentChat, this.user});

  final RecentChat recentChat;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                      user: user,
                      friendId: recentChat.friend.id,
                      chatId: recentChat.chatId))),
          isThreeLine: true,
          leading: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: recentChat.friend.photoUrl.isEmpty
                      ? AssetImage(kPlaceholderImage)
                      : NetworkImage(recentChat.friend.photoUrl),
                  fit: BoxFit.contain,
                ),
                shape: BoxShape.circle),
          ),
          title: Text(
            recentChat.friend.name,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 14.0),
          ),
          subtitle: Text(recentChat.lastMessage,
              style: TextStyle(color: Colors.grey)),
        ));
  }
}
