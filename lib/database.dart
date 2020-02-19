import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/model/user.dart';

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

Stream<QuerySnapshot> getRecentChatsById(FirebaseUser user) {
  return firestore.collection('users/${user.uid}/conversation').snapshots();
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

void confirmFiend({FirebaseUser user, String friendId}) {
  firestore
      .document("users/${user.uid}/friends/$friendId")
      .setData({"name": "test", "email": "test@test.com"});

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

CollectionReference getFriendRequest(FirebaseUser user) {
  return firestore.collection("friend_request_to/${user.uid}/from");
}

CollectionReference getFriendList(FirebaseUser user) {
  return firestore.collection("users/${user.uid}/friends");
}

CollectionReference getNewUsersList() {
  return firestore.collection("public_users");
}

Future<User> getUserById(String id) {
  return firestore.document("user/$id").get().then((i) => User.fromFirebase(i));
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
      print(document.data);

      String userId = document.data["sender"];
      if (!users.containsKey(userId)) {
        users[userId] = await getUserById(userId);
      }
    }
    print(users);
    return snapshot.documents
        .map((document) =>
            Message.fromFirebase(document, users[document.data["sender"]]))
        .toList();
  });
}
