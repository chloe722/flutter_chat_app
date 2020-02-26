import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/add_friend_screen.dart';
import 'package:flash_chat/screens/friend_screen.dart';
import 'package:flash_chat/screens/list_wheel_scroll_view.dart';
import 'package:flash_chat/screens/profile_screen.dart';
import 'package:flash_chat/screens/recent_chats_screen.dart';
import 'package:flash_chat/webrtc/call_sample.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.user, this.logOutCallback});

  final FirebaseUser user;
  final VoidCallback logOutCallback;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _widgets;
  int _currentIndex = 0;

  @override
  void initState() {
    _widgets = [
      RecentChatsScreen(
        user: widget.user,
      ),
      FriendsScreen(user: widget.user),
      ProfileScreen(user: widget.user, logOutCallback: widget.logOutCallback),
      CallSample(),
//      ListWheelScrollViewScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            if (_currentIndex == 1)
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddFriendScreen(user: widget.user))),
              )
          ],
//        flexibleSpace: SafeArea(
//          child: TabBar(
//            indicator: CustomTabIndicator(),
//            indicatorSize: TabBarIndicatorSize.label,
//            tabs: <Widget>[
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
//                child: Tab(icon: Icon(Icons.chat, color: kBrown,)),
//              ),
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
//                child: Tab(icon: Icon(Icons.people, color: kBrown)),
//              ),
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
//                child: Tab(icon: Icon(Icons.person, color: kBrown)),
//              )
//            ],
//          ),
//        ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _currentIndex,
          selectedItemColor: kBrown,
          unselectedItemColor: Colors.grey,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), title: Text("Chats")),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), title: Text("Friends")),

            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text("Settings")),

            BottomNavigationBarItem(
                icon: Icon(Icons.phone), title: Text("WebRTC"))
          ],
        ),
        body: _widgets[_currentIndex]
//          TabBarView(
//            children: <Widget>[
//              RecentChatsScreen(user: widget.user,),
//              FriendsScreen(user: widget.user),
//              ProfileScreen(user: widget.user, logOutCallback: widget.logOutCallback),
//            ],
//          )
        );
  }
}

//
//class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//
//      decoration: BoxDecoration(
//        borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0)),
//      ),
//      child: TabBar(
//        indicator: CustomTabIndicator(),
//        indicatorSize: TabBarIndicatorSize.label,
//        tabs: <Widget>[
//          Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
//            child: Tab(icon: Icon(Icons.chat, color: Colors.blueGrey,)),
//          ),
//          Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
//            child: Tab(icon: Icon(Icons.people, color: Colors.blueGrey)),
//          ),
//          Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
//            child: Tab(icon: Icon(Icons.person, color: Colors.blueGrey)),
//          )
//        ],
//      ),
//    );
//  }
//
//  @override
//  // TODO: implement preferredSize
//  Size get preferredSize => const Size.fromHeight(40.0);
//}
