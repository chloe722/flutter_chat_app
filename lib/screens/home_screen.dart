import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/add_friend_screen.dart';
import 'package:flash_chat/screens/friend_screen.dart';
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
  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    _widgets = [
      RecentChatsScreen(
        user: widget.user,
      ),
      FriendsScreen(user: widget.user),
      ProfileScreen(user: widget.user, logOutCallback: widget.logOutCallback),
      CallSample(),
    ];
    super.initState();
  }

  void _onTabSelected(int index) {
    print("page view index: $index");
    _pageController.jumpToPage(index);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (_currentIndex == 2)
            ? PreferredSize(
                preferredSize: Size(0.0, 0.0),
                child: Container(),
              )
            : AppBar(
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
              ),
        body:  Stack(
          children: <Widget>[
            _widgets[_currentIndex],
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                child: BottomNavigationBar(
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
              ),
            ),
          ],
        )
    );
  }
}

class FabBottomItem {
  IconData icon;
  String text;

  FabBottomItem({this.icon, this.text});
}

class FabBottomAppBar extends StatefulWidget {
  FabBottomAppBar(
      {this.onTabSelected,
      this.items,
      this.notchedShape,
      this.selectedColor = kBrown,
      this.color = Colors.grey,
      this.backgroundColor,
      this.height = 60.0,
      this.iconSize = 24.0}) {
    assert(this.items.length == 2 || this.items.length == 4);
  }

  final ValueChanged<int> onTabSelected;
  final List<FabBottomItem> items;
  final NotchedShape notchedShape;
  final Color selectedColor;
  final Color color;
  final Color backgroundColor;
  final double height;
  final double iconSize;

  @override
  _FabBottomAppBarState createState() => _FabBottomAppBarState();
}

class _FabBottomAppBarState extends State<FabBottomAppBar> {
  int _selectedIndex = 0;

  void _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      setState(() {
        _selectedIndex = index;
        print("selected: $_selectedIndex");
      });
    });
  }

  Widget _buildBottomItem(
      {FabBottomItem item, int index, ValueChanged<int> onPress}) {
    bool _isSelected = _selectedIndex == index;
    Color _color = _isSelected? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPress(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.icon, size: widget.iconSize, color: _color),
                Text(_isSelected?item.text : "", style: TextStyle(color: _color)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(
        widget.items.length,
        (int index) => _buildBottomItem(
            item: widget.items[index], index: index, onPress: _updateIndex));
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items),
      ),
    );
  }
}
