import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        leading: null,
        title: Text('️Chat'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[

            Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                    child: WriteMessageTile())),
          ],
        ),
      ),
    );
  }
}


class ChatBubbleTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}





class WriteMessageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kMessageContainerDecoration,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kMessageTextFieldDecoration,
            ),
          ),
          FlatButton(
            onPressed: () {
              //Implement send functionality.
            }, child: Icon(Icons.send, color: Colors.grey,),
          ),
        ],
      ),
    );
  }
}

