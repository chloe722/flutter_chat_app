
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/model/message.dart';
import 'package:flash_chat/widgets/chat/chat_bubble.dart';
import 'package:flutter/material.dart';

class MessageStream extends StatefulWidget {
  MessageStream({this.user, this.chatId});

  final FirebaseUser user;
  final String chatId;

  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: getMessagesByChatId(widget.chatId),
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (snapshot.hasError) print(snapshot.error);
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return snapshot.hasData && data != null
                  ? Expanded(
                child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (c, i) {
                      bool _isLatestMsg = data.first == data[i];
                      bool _isMe = widget.user.uid == data[i].author.id;

                      return ChatBubble(
                        user: data[i].author,
                        isMe: _isMe,
                        isLatestMsg: _isLatestMsg,
                        message: data[i],
                      );
                    }),
              )
                  : Text("Loading");
          }
        });
  }
}