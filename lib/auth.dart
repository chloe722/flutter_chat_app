import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


abstract class BaseAuth {
  Future<FirebaseUser> logIn({String email, String password});

  Future<FirebaseUser> googleLogIn();

  void googleLogOut();

  Future<FirebaseUser> register({String email, String password});

  Future<FirebaseUser> getCurrentUser();

  Future<void> logOut();
}

class Auth implements BaseAuth {

  final GoogleSignIn _googleLogIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Future<FirebaseUser> googleLogIn() async {
    final GoogleSignInAccount googleUser = await _googleLogIn.signIn();
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

    return user;
  }

  @override
  void googleLogOut() async {
    await _googleLogIn.signOut();
  }

  @override
  Future<FirebaseUser> logIn({String email, String password}) async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
    return user;
  }

  @override
  Future<FirebaseUser> register({String email, String password}) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
    )).user;

    return user;
  }


  @override
  Future<FirebaseUser> getCurrentUser() async {
  FirebaseUser user = await _auth.currentUser();
    return user;
  }


  @override
  Future<void> logOut() {
    return _auth.signOut();
  }

}

