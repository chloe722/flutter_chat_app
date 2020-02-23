
import 'package:flash_chat/model/user.dart';

class RecentChat{

  User friend;
  String chatId;
  String lastMessage;

  RecentChat({this.friend, this.chatId, this.lastMessage});

  factory RecentChat.fromData({User friend, String chatId, String lastMessage}){
    return RecentChat(
      friend: friend,
      chatId: chatId,
      lastMessage: lastMessage,
    );
  }

}