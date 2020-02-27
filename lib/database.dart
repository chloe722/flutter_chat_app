import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/model/avaliable_users.dart';
import 'package:flash_chat/model/recent_chat.dart';
import 'package:flash_chat/model/user.dart';
import 'package:flash_chat/utils.dart';
import 'model/message.dart';
import 'package:rxdart/streams.dart';

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

Stream<List<RecentChat>> getRecentChats({FirebaseUser user}) {
  return firestore
      .collection("users/${user.uid}/conversation")
      .snapshots()
      .asyncMap((snapshot) {
    return Future.wait(snapshot.documents.map((document) async {
      String _friendId = document.data["from"];
      User _friend = await getUserById(_friendId);
      return RecentChat.fromDatabase(document: document, friend: _friend);
    }));
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
    return ([user.uid, friendId]..sort()).join(","); // Prevent duplicate chats
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

void confirmFriend({FirebaseUser user, User friend}) {
  firestore
      .document("users/${user.uid}/friends/${friend.id}")
      .setData({"name": friend.name, "email": friend.email});

  firestore
      .document("users/${friend.id}/friends/${user.uid}")
      .setData({"name": user.displayName, "email": user.email});

  clearFriendRequest(user: user, friendId: friend.id);
}

void clearFriendRequest({FirebaseUser user, String friendId}) {
  firestore.document("friend_request_to/${user.uid}/from/$friendId").delete();
  firestore.document("friend_request_from/$friendId/to/${user.uid}").delete();
}

void rejectFriendRequest({FirebaseUser user, String friendId}) {
  clearFriendRequest(user: user, friendId: friendId);
}

void unFriend({FirebaseUser user, String friendId}) {
  firestore.document("users/${user.uid}/friend/$friendId").delete();
  firestore.document("users/$friendId/friend/${user.uid}").delete();
}

void addFriend({FirebaseUser user, String friendId}) {
  firestore
      .document("friend_request_to/$friendId/from/${user.uid}")
      .setData({"timestamp": FieldValue.serverTimestamp()});
  firestore
      .document("friend_request_from/${user.uid}/to/$friendId")
      .setData({"timestamp": FieldValue.serverTimestamp()});
}

Stream<List<User>> getFriendRequest(FirebaseUser user) {
  return firestore
      .collection("friend_request_to/${user.uid}/from")
      .snapshots()
      .asyncMap((snapshot) async {
    return Future.wait(snapshot.documents.map((document) async {
      User _friendRequest = await getUserById(document.documentID);
      return _friendRequest;
    }).toList());
  });
}

Stream<List<User>> getFriendList(FirebaseUser user) {
  return firestore
      .collection("users/${user.uid}/friends")
      .snapshots()
      .asyncMap((snapshot) async {
    return Future.wait(snapshot.documents.map((document) async {
      User _friend = await getUserById(document.documentID);
      return _friend;
    }).toList());
  });
}

Stream<List<AvailableUser>> getAvailableUsersList({FirebaseUser user}) {
  var usersStream = firestore
      .collection("public_users")
      .snapshots()
      .asyncMap((snapshot) async {
    return Future.wait(snapshot.documents
        .where((document) => document.documentID != user.uid)
        .map((document) async {
      User _user = await getUserById(document.documentID);
      return _user;
    }).toList());
  });

  var _requestStream =
      firestore.collection("friend_request_from/${user.uid}/to").snapshots();

  var _friendsStream =
      firestore.collection("users/${user.uid}/friends").snapshots();

  return CombineLatestStream.combine3(usersStream, _requestStream, _friendsStream,
      (List<User> allUsers, QuerySnapshot requestUsers,
          QuerySnapshot friendsSnapshot) {

    return getAvailableUsers(
        allUsers, requestUsers.documents, friendsSnapshot.documents);
  });
}

List<AvailableUser> getAvailableUsers(
    List<User> allUsers,
    List<DocumentSnapshot> requestUsers,
    List<DocumentSnapshot> friendsSnapshot) {
  return allUsers
      .where((user) => !_isFriend(user, friendsSnapshot))
      .map((user) => AvailableUser(
          user: user, requestSent: _requestHasBeenSent(user, requestUsers)))
      .toList();
}

bool _isFriend(User user, List<DocumentSnapshot> friendsSnapshot) {
  return friendsSnapshot
          .where((friend) => friend.documentID != user.id)
          .length >
      0;
}

bool _requestHasBeenSent(User user, List<DocumentSnapshot> requestUsers) {
  return requestUsers
          .where((requestUser) => requestUser.documentID == user.id)
          .length >
      0;
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
    ///Prefetch users
    await Future.wait(snapshot.documents.map((document) async {
      String userId = document.data["sender"];
      if (!users.containsKey(userId)) {
        users[userId] = await getUserById(userId);
      }
    }));

//    for (var document in snapshot.documents) {
//      String userId = document.data["sender"];
//      if (!users.containsKey(userId)) {
//        users[userId] = await getUserById(userId);
//      }
//    }
    ///Convert to list
    return snapshot.documents
        .map((document) =>
            Message.fromFirebase(document, users[document.data["sender"]]))
        .toList();
  });
}
