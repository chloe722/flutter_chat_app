import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/friend_screen.dart';
import 'package:flash_chat/screens/profile_screen.dart';
import 'package:flash_chat/screens/recent_chats_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.user, this.logOutCallback});

  final FirebaseUser user;
  final VoidCallback logOutCallback;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: kFirebrick,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(

            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(icon: Icon(Icons.chat_bubble)),
                Tab(icon: Icon(Icons.people)),
                Tab(icon: Icon(Icons.person))
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              RecentChatsScreen(user: widget.user,),
              FriendsScreen(user: widget.user),
              ProfileScreen(user: widget.user, logOutCallback: widget.logOutCallback),
            ],
          )
        ),
      ),
    );
  }
}
