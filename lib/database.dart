import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/model/recent_chat.dart';
import 'package:flash_chat/model/user.dart';
import 'package:flash_chat/utils.dart';

import 'model/message.dart';

Firestore firestore = Firestore.instance;

Future<void> updateProfileData(
    {FirebaseUser user,
    String name,
    String userName,
    String photoUrl,
    String phone,
    String about,
    String status}) async {
  await firestore.collection("users").document(user.uid).updateData({
    if (name != null) "name": name,
    if (userName != null) "userName": userName,
    if (photoUrl != null) "photoUrl": photoUrl,
    if (phone != null) "phone": phone,
    if (about != null) "about": about,
    if (status != null) "status": status,
  });
  await firestore.collection("public_users").document(user.uid).updateData({
    if (name != null) "name": name,
    if (userName != null) "userName": userName,
    if (photoUrl != null) "photoUrl": photoUrl,
    if (about != null) "about": about,
    if (status != null) "status": status,
  });
}

void updateUserFromFirebaseUser(FirebaseUser user) async {
  //Update data to server if new user
  if (user != null) {
    final QuerySnapshot result = await firestore
        .collection("users")
        .where("id", isEqualTo: user.uid)
        .getDocuments();

    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length == 0) {
      firestore.document("users/${user.uid}").setData({
        "id": user.uid,
        "name": user.displayName,
        "email": user.email,
        "photoUrl": user.photoUrl,
      });

      firestore.document("public_users/${user.uid}").setData({
        "id": user.uid,
        "name": user.displayName,
        "photoUrl": user.photoUrl,
      });
    }
  }
}

Stream<DocumentSnapshot> getUserProfileById(FirebaseUser user) {
  return firestore.collection('users').document(user.uid).snapshots();
}
//TODO delete
//Stream<QuerySnapshot> getFullChatsById(FirebaseUser user) {
//
//  return firestore.collection('users/${user.uid}/conversation').snapshots();
//}

Stream<List<RecentChat>> getRecentChats({FirebaseUser user}) {
  List<RecentChat> recentChats = [];

  return firestore
      .collection("users/${user.uid}/conversation")
      .snapshots()
      .asyncMap((snapshot) async {
    for (var document in snapshot.documents) {
      String _friendId = document.data["from"];
      String _chatId = document.documentID;
      String _lastMessage = document.data["lastMessage"];
      User _friend = await getUserById(_friendId);
      recentChats.add(RecentChat.fromData(
          friend: _friend, chatId: _chatId, lastMessage: _lastMessage));
    }
    return recentChats;
  });
}

Future<String> getChatId({FirebaseUser user, String friendId}) async {
  var result = await firestore
      .collection("users/${user.uid}/conversation")
      .where("from", isEqualTo: friendId)
      .getDocuments();
  List<DocumentSnapshot> data = result.documents;

  if (data.length > 0) {
    print("existing chatId: ${data.first.documentID}");
    return data.first.documentID;
  } else {
    print("new chatId");

    return createCryptoRandomString();
  }
}

void sendContent(
    {FirebaseUser user,
    String chatId,
    int type,
    String friendId,
    String sender,
    String content}) {
  firestore
      .document("users/${user.uid}/conversation/$chatId")
      .setData({"from": friendId, "lastMessage": content});

  firestore
      .document("users/$friendId/conversation/$chatId")
      .setData({"from": user.uid, "lastMessage": content});

  firestore.collection("conversation/$chatId/messages").add({
    "timestamp": FieldValue.serverTimestamp(),
    "type": type,
    "sender": user.uid,
    "content": content,
  });
}

//TODO pass friend object instad of id

void confirmFriend({FirebaseUser user, String friendId}) {
  firestore
      .document("users/${user.uid}/friends/$friendId")
      .setData({"name": "test", "email": "test@test.com"}); //TODO

  firestore
      .document("users/$friendId/friends/${user.uid}")
      .setData({"name": user.displayName, "email": user.email});

  rejectFriendRequest(user: user, friendId: friendId);
}

void rejectFriendRequest({FirebaseUser user, String friendId}) {
  firestore.document("friend_request_to/${user.uid}/from/$friendId").delete();
}

void deleteFriend({FirebaseUser user, String friendId}) {
  firestore.document("users/${user.uid}/friend/$friendId").delete();
  firestore.document("users/$friendId/friend/${user.uid}").delete();
}

void addFriend({FirebaseUser user, String friendId}) {
  firestore
      .document("friend_request_to/$friendId/from/${user.uid}")
      .setData({"name": user.displayName, "email": user.email});
}

Stream<List<User>> getFriendRequest(FirebaseUser user) {
  List<User> friendRequests = [];
  return firestore.collection("friend_request_to/${user.uid}/from").snapshots().asyncMap((snapshot) async {
    for (var document in snapshot.documents) {
      print("request friend ID: ${document.documentID}");
      User _friendRequest = await getUserById(document.documentID);
      friendRequests.add(_friendRequest);
    }
    return friendRequests;

  });
}

Stream<List<User>> getFriendList(FirebaseUser user) {
  List<User> friends = [];

  return firestore
      .collection("users/${user.uid}/friends")
      .snapshots()
      .asyncMap((snapshot) async {
    for (var document in snapshot.documents) {
      User _friend = await getUserById(document.documentID);
      friends.add(_friend);
    }
    return friends;
  });
}

CollectionReference getNewUsersList() {
  return firestore.collection("public_users");
}

Future<User> getUserById(String id) {
  return firestore
      .document("public_users/$id")
      .get()
      .then((document) => User.fromFirebase(document));
}

Stream<List<Message>> getMessagesByChatId(String chatId) {
  Map<String, User> users = {};

  return firestore
      .collection("conversation/$chatId/messages")
      .reference()
      .orderBy("timestamp", descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
    ///Prefetch users (return future)
    for (var document in snapshot.documents) {
      String userId = document.data["sender"];
      if (!users.containsKey(userId)) {
        users[userId] = await getUserById(userId);
      }
    }
//    print(users);
    return snapshot.documents
        .map((document) =>
            Message.fromFirebase(document, users[document.data["sender"]]))
        .toList();
  });
}
