import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/image_manager.dart';
import 'package:flash_chat/model/message.dart';
import 'package:flash_chat/model/user.dart';
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
        backgroundColor: kDodgerBlue,
        appBar: AppBar(
          leading: null,
          title: Text(
            "Chat",
            style: kAppBarTextStyle,
          ),
          iconTheme: IconThemeData(color: kBrown),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: Column(
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

class MessageStream extends StatelessWidget {
  MessageStream({this.user, this.chatId});

  final FirebaseUser user;
  final String chatId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: getMessagesByChatId(chatId),
        builder: (context, snapshot) {
          var data = snapshot.data;
          if(snapshot.hasError) print(snapshot.error);
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
                                print('user id: ${user.uid}   list of id: ${data[i].author.id}');
                                return ChatBubble(
                                  user: data[i].author,
                                  isMe: user.uid == data[i].author.id,
                                  message: data[i],
                                );
                              }),
                    )
                  : Text("Loading");
          }
        });
  }
}

class ChatBubble extends StatelessWidget {
  ChatBubble({this.user, this.isMe, this.message});

  final User user;
  final bool isMe;
  final Message message;

  //0 = message, 1=sticker, 2=image
  Widget _buildText() {
    return Material(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(isMe ? 0.0 : 30.0),
          topLeft: Radius.circular(isMe ? 30.0 : 0.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0)),
      elevation: 1.0,
      color: isMe ? Colors.amber[300] : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(message.content ?? "", softWrap: true),
      ),
    );
  }

  Widget _builtImage() {
    return CachedNetworkImage(
        placeholder: (context, url) => Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Material(
              child: Text("Image is not available"),
              borderRadius: BorderRadius.circular(10.0),
            ),
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
        imageUrl: message.content ?? "");
  }

  Widget _builtSticker() {
    //TODO
  }


  Widget _buildAvatar() {
    return Padding(
      padding: EdgeInsets.only(right: isMe? 0.0 : 8.0, left: isMe? 8.0: 0.0 ),
      child: CircleAvatar(backgroundImage: user.photoUrl.isEmpty?
      AssetImage("images/mario_profile.png") : CachedNetworkImageProvider(user.photoUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if(isMe == false) _buildAvatar(),
          if (message.type == 0) _buildText(),
          if (message.type == 1) _builtImage(),
          if (message.type == 2) _builtSticker(),
          if(isMe == true) _buildAvatar(),
        ],
      ),
    );
  }
}

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

  void _getGiphy() {
  }

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
