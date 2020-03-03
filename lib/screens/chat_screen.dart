import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/image_manager.dart';
import 'package:flash_chat/widgets/chat/chat_input_tile.dart';
import 'package:flash_chat/widgets/chat/message_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Firestore firestore = Firestore.instance;

class ChatScreen extends StatefulWidget {
  ChatScreen({this.user, this.chatId, this.friendId});

  static String id = "chat_screen";
  final FirebaseUser user;
  final String chatId;
  final String friendId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //0 = message, 1=image, 2=sticker

  void _getImageUrl() async {
    String _url = await getImage(ImageType.CHAT);
    setState(() {
      sendContent(
          user: widget.user,
          chatId: widget.chatId,
          friendId: widget.friendId,
          type: 1,
          content: _url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: kGreyBlack,
        appBar: AppBar(
          leading: null,
          title: Text(
            "Chat",
            style: kAppBarTextStyle,
          ),
//          actions: <Widget>[IconButton(icon: Icon(Icons.translate),onPressed: ()=> translateMessage("Hello, How are you?"),)],
          iconTheme: IconThemeData(color: kBrown),
          centerTitle: true,
          backgroundColor: kBlurYellow,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MessageStream(
              user: widget.user,
              chatId: widget.chatId,
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: InputMessageTile(
                  user: widget.user,
                  chatId: widget.chatId,
                  friendId: widget.friendId,
                  firestore: firestore,
                  getImage: _getImageUrl,
                )),
          ],
        ),
      ),
    );
  }
}
