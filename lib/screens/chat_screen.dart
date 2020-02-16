import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

Firestore firestore = Firestore.instance;

class ChatScreen extends StatefulWidget {
  ChatScreen(this.user);

  static String id = 'chat_screen';
  final FirebaseUser user;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //0 = message, 1=image, 2=sticker

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print("image file: $image");

    if (image != null) {
      uploadFile(image);
    } else {
      print('Uploaded failed');
    }
  }

  Future uploadFile(File image) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((url) {
      setState(() {
        sendContent(type: 1, sender: widget.user.email, content: url);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: kDodgerBlue,
        appBar: AppBar(
          leading: null,
          title: Text('️Chat', style: kAppBarTextStyle,),
          iconTheme: IconThemeData(color: kBrown),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: Column(
          children: <Widget>[
            MessageStream(
              user: widget.user,
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: InputMessageTile(
                  user: widget.user,
                  firestore: firestore,
                  getImage: getImage,
                )),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  MessageStream({this.user});

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("chat")
            .reference()
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          var data = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return snapshot.hasData && data != null
                  ? Expanded(
                      child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: data.documents.length,
                          itemBuilder: (c, i) {
                            return ChatBubble(
                              isMe: user.email ==
                                  data.documents[i].data["sender"],
                              type: data.documents[i].data["type"],
                              content: data.documents[i].data["content"],
                              sender: data.documents[i].data["sender"],
                            );
                          }),
                    )
                  : Text("Loading");
          }
        });
  }
}

class ChatBubble extends StatelessWidget {
  ChatBubble({this.content, this.sender, this.type, this.isMe});

  //0 = message, 1=sticker, 2=image

  final String content;
  final String sender;
  final int type;
  final bool isMe;

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
        child: Text(content ?? "", softWrap: true),
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
              child: Text('Image is not available'),
              borderRadius: BorderRadius.circular(10.0),
            ),
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
        imageUrl: content);
  }

  Widget _builtSticker() {
    //TODO
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender ?? ""),
          SizedBox(height: 5.0),
          if (type == 0) _buildText(),
          if (type == 1) _builtImage(),
          if (type == 2) _builtSticker(),
        ],
      ),
    );
  }
}

class InputMessageTile extends StatelessWidget {
  InputMessageTile({this.firestore, this.user, this.getImage});

  final messageTextEditingController = TextEditingController();

  final Firestore firestore;
  final FirebaseUser user;
  String text;
  Function getImage;

  //0 = message, 1=image, 2=sticker

  void _send() {
    messageTextEditingController.clear();
    sendContent(type: 0, sender: user.email, content: text);
  }

  void _getGiphy() {
    print('get stickers');
    
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
