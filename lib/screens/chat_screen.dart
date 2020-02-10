import 'package:firebase_database/firebase_database.dart';
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
  void initState() {
    super.initState();
  }


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
            SingleChildScrollView(child: Column(

              children: <Widget>[
                ChatBubbleTile(),
              ],
            )),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
      shape: BoxShape.rectangle,
      border: Border.all(style: BorderStyle.solid, color: Colors.grey),
      ),
      child: Text("test", softWrap: true),

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

