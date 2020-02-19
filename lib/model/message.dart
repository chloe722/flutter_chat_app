import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/model/user.dart';

class Message {
  User author;
  int type;
  String content;
  Timestamp timestamp;

  Message({this.author, this.type, this.content, this.timestamp});

  factory Message.fromFirebase(DocumentSnapshot snapshot, User user) {
    return Message(
        author: user,
        content: snapshot["content"],
        timestamp: snapshot["timestamp"],
        type: snapshot["type"]);
  }
}
