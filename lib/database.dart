import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/Utils.dart';
import 'dart:math';

import 'screens/model/status.dart';

Firestore firestore = Firestore.instance;

Future<void> updateProfileData(
    {FirebaseUser user,
    String name,
    String userName,
    String photoUrl,
    String phone,
    String about,
    String status}) async {
  await firestore.collection('users').document(user.uid).updateData({
    if (name != null) 'name': name,
    if (userName != null) 'userName': userName,
    if (photoUrl != null) 'photoUrl': photoUrl,
    if (phone != null) 'phone': phone,
    if (about != null) 'about': about,
    if (status != null) 'status': status,
  });
}

void updateUserFromFirebaseUser(FirebaseUser user) async {
  //Update data to server if new user
  if (user != null) {
    final QuerySnapshot result = await firestore
        .collection('users2')
        .where('id', isEqualTo: user.uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      firestore.document('users2/${user.uid}/info/info').setData({
        'id': user.uid,
        'name': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
      });
    }
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
      .document('users2/${user.uid}/conversation/$chatId')
      .setData({
    'from': friendId,
    'lastMessage': content});

  firestore
      .document('users2/$friendId/conversation/$chatId')
      .setData({
    'from': user.uid,
    'lastMessage': content});

  firestore.collection('conversation/$chatId/messages').add({
    'timestamp': FieldValue.serverTimestamp(),
    'type': type,
    'sender': user.uid,
    'content': content,
  });
}

//TODO pass friend object instad of id

void confirmFiend({FirebaseUser user, String friendId}) {
  firestore
      .document('users2/${user.uid}/friends/$friendId')
      .setData({'name': 'test', 'email': 'test@test.com'});

  firestore
      .document('users2/$friendId/friends/${user.uid}')
      .setData({'name': user.displayName, 'email': user.email});

  rejectFriendRequest(user: user, friendId: friendId);
}

void rejectFriendRequest({FirebaseUser user, String friendId}) {
  firestore.document('friend_request_to/${user.uid}/from/$friendId').delete();
}

void deleteFriend({FirebaseUser user, String friendId}) {
  firestore.document('users2/${user.uid}/friend/$friendId').delete();
  firestore.document('users2/$friendId/friend/${user.uid}').delete();
}

void addFriend({FirebaseUser user, String friendId}) {
  firestore
      .document('friend_request_to/$friendId/from/${user.uid}')
      .setData({'name': user.displayName, 'email': user.email});
}

CollectionReference getFriendRequest(FirebaseUser user) {
  return firestore.collection('friend_request_to/${user.uid}/from');
}

CollectionReference getFriendList(FirebaseUser user) {
  return firestore.collection('users2/${user.uid}/friends');
}
