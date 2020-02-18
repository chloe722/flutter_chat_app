import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/friend_screen.dart';
import 'package:flash_chat/screens/profile_screen.dart';
import 'package:flash_chat/screens/recent_chats_screen.dart';
import 'package:flash_chat/widgets/custom_tab_indicator.dart';
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
    return DefaultTabController(
        length: 3,
        child: Scaffold(
//          drawer: Drawer(
//            child: ListView(
//              children: <Widget>[
//                DrawerHeader(
//                  child: Text('Drawer Header'),
//                  decoration: BoxDecoration(
//                    color: Colors.blue,
//                  ),
//                ),
//                ListTile(),
//                ListTile(),
//                ListTile(),
//
//              ],
//            ),
//          ),
          appBar: AppBar(
            flexibleSpace: SafeArea(
              child: TabBar(
                indicator: CustomTabIndicator(),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                    child: Tab(icon: Icon(Icons.chat, color: kBrown,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                    child: Tab(icon: Icon(Icons.people, color: kBrown)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                    child: Tab(icon: Icon(Icons.person, color: kBrown)),
                  )
                ],
              ),
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
