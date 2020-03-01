import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/model/user.dart';

class Message {
  User author;
  int type;
  String content;
  Timestamp timestamp;
  String id;

  Message({this.author, this.type, this.content, this.timestamp, this.id});

  factory Message.fromFirebase(DocumentSnapshot snapshot, User user) {
    return Message(
        author: user,
        content: snapshot["content"],
        timestamp: snapshot["timestamp"],
        type: snapshot["type"],
        id: snapshot.documentID);
  }

  /// Equality check
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Message &&
              runtimeType == other.runtimeType &&
              id == other.id;

  /// use message as a key in a map Map<Message, something>
  @override
  int get hashCode => id.hashCode;

}
