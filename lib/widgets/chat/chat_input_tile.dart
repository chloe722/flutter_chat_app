import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flutter/material.dart';

class InputMessageTile extends StatelessWidget {
  InputMessageTile(
      {this.firestore, this.user, this.getImage, this.friendId, this.chatId});

  final messageTextEditingController = TextEditingController();

  final Firestore firestore;
  final FirebaseUser user;
  String text;
  Function getImage;
  String chatId;
  String friendId;

  //0 = message, 1=image, 2=sticker
  void _send() {
    messageTextEditingController.clear();
    sendContent(
        user: user, type: 0, chatId: chatId, friendId: friendId, content: text);
  }

  void _getGiphy() {}

  Widget _buildCustomButton({IconData icon, Color color, Function onTap}) {
    return Material(
      child: InkWell(
        onTap: () => onTap(),
        child: Center(
          child: Icon(
            icon,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kMessageContainerDecoration,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _buildCustomButton(
                icon: Icons.image, color: Colors.grey, onTap: getImage),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 8.0),
            child: _buildCustomButton(
                icon: Icons.face, color: Colors.grey, onTap: _getGiphy),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              controller: messageTextEditingController,
              onChanged: (value) => text = value,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: kMessageTextFieldDecoration,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _buildCustomButton(
                icon: Icons.send, color: kDodgerBlue, onTap: _send),
          ),
        ],
      ),
    );
  }
}
