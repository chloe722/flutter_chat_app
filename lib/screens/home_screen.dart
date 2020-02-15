import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/bluetooth_screen.dart';
import 'package:flash_chat/screens/recent_chats_screen.dart';
import 'package:flash_chat/screens/friend_screen.dart';
import 'package:flash_chat/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.user, this.logOutCallback});

  final FirebaseUser user;
  final VoidCallback logOutCallback;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget> screens;

  @override
  void initState() {
    screens = [
      RecentChatsScreen(user: widget.user,),
      FriendsScreen(user: widget.user),
      ProfileScreen(user: widget.user, logOutCallback: widget.logOutCallback),
      BluetoothRoot(),
    ];
    super.initState();
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              title: Text("Chat"), icon: Icon(Icons.chat_bubble)),
          BottomNavigationBarItem(
              title: Text("Friend"), icon: Icon(Icons.people)),
          BottomNavigationBarItem(
              title: Text("Profile"), icon: Icon(Icons.person)),
          BottomNavigationBarItem(
              title: Text("Bluetooth"), icon: Icon(Icons.bluetooth)),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemSelected,
        selectedItemColor: Colors.lightBlue,
      ),
      body: screens.elementAt(_selectedIndex),
    );
  }
}
