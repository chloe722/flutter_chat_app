import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Firestore firestore = Firestore.instance;

class ChatScreen extends StatefulWidget {
  ChatScreen(this.user);

  static String id = 'chat_screen';
  final FirebaseUser user;

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
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
          leading: null,
          title: Text('️Chat'),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Column(
          children: <Widget>[
            MessageStream(
              user: widget.user,
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child:
                    InputMessageTile(user: widget.user, firestore: firestore)),
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
                              text: data.documents[i].data["text"],
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
  ChatBubble({this.text, this.sender, this.isMe});

  final String text;
  final String sender;
  final bool isMe;

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
          Material(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(isMe ? 0.0 : 30.0),
                topLeft: Radius.circular(isMe ? 30.0 : 0.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
            elevation: 1.0,
            color: isMe ? Colors.orangeAccent[200] : Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text ?? "", softWrap: true),
            ),
          ),
        ],
      ),
    );
  }
}

class InputMessageTile extends StatelessWidget {
  InputMessageTile({this.firestore, this.user});

  final messageTextEditingController = TextEditingController();

  final Firestore firestore;
  final FirebaseUser user;
  String text;

  void send() {
    messageTextEditingController.clear();
    firestore.collection('chat').add({
      'timestamp': FieldValue.serverTimestamp(),
      'sender': user.email,
      'text': text,
    });
  }

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
              controller: messageTextEditingController,
              onChanged: (value) => text = value,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: kMessageTextFieldDecoration,
            ),
          ),
          FlatButton(
            onPressed: () => send(),
            child: Icon(
              Icons.send,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
