import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> handleSignIn() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);


  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  print(user);
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);


  print('signed in ' + user.displayName);

  return user;
}

void signOutGoogleAccount() async {
  await _googleSignIn.signOut();
}

void handleRegister({String email, String pwd}) async {
  final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
    email: email,
    password: pwd,
  )).user;

  print(user);
}


