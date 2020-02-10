import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Center(
        child: Container(
          child: ListView(
            children: <Widget>[
              FriendTile(),
              FriendTile(),
              FriendTile()

            ],
          ),
        ),
      ),
    );
  }
}


class FriendTile extends StatelessWidget {
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
