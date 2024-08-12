
import 'package:deafassist/views/screens/deaf/chatDeaf.dart';
import 'package:deafassist/views/screens/deaf/homeDeaf.dart';
import 'package:deafassist/views/screens/deaf/profileDeaf.dart';
import 'package:deafassist/views/screens/deaf/settingsDeaf.dart';
import 'package:flutter/material.dart';

class BottomNavDeaf extends StatefulWidget {
  const BottomNavDeaf({Key? key}) : super(key: key);

  @override
  _BottomNavDeafState createState() => _BottomNavDeafState();
}

class _BottomNavDeafState extends State<BottomNavDeaf> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
   HomeDeaf(),
   ChatDeaf(), 
   SettingsDeaf(),
   ProfileDeaf()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFFF8B11B),
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.home_filled),
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.chat_outlined),
              icon: Icon(Icons.chat),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.settings_accessibility_outlined),
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.person_2_outlined),
              icon: Icon(Icons.person_2),
              label: "Profile",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
    );
  }
}