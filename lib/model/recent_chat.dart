
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/model/user.dart';

class RecentChat{

  User friend;
  String chatId;
  String lastMessage;

  RecentChat({this.friend, this.chatId, this.lastMessage});

  factory RecentChat.fromDatabase({DocumentSnapshot document, User friend}){
    return RecentChat(
      friend: friend,
      chatId: document.documentID,
      lastMessage: document.data["lastMessage"],
    );
  }

}