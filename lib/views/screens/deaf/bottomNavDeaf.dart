import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/views/screens/auth/profilesample.dart';
import 'package:deafassist/views/screens/deaf/homeDeaf.dart';
import 'package:deafassist/views/screens/deaf/main_chat_list.dart';
import 'package:flutter/material.dart';

class BottomNavDeaf extends StatefulWidget {
  const BottomNavDeaf({super.key});

  @override
  _BottomNavDeafState createState() => _BottomNavDeafState();
}

class _BottomNavDeafState extends State<BottomNavDeaf> with SingleTickerProviderStateMixin {
  int _selectedIndex = 1; // Set initial page to the Chat page (index 1)
  late AnimationController _animationController;

  static List<Widget> _widgetOptions = <Widget>[
    ChatMainList(),
    HomeDeaf(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              blurRadius: 10, // Softness of the shadow
              spreadRadius: 2, // Size of the shadow
              offset: const Offset(0, -2), // Position of the shadow
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryColor,
          backgroundColor: Colors.transparent, // Make background transparent
          elevation: 0,
          items: [
            _buildNavBarItem(Icons.chat, "Chat", 0),
            _buildNavBarItem(Icons.home, "Deaf Assist", 1, isDeafAssist: true), // Mark this item as Deaf Assist
            _buildNavBarItem(Icons.person_2, "My Account", 2),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(IconData icon, String label, int index, {bool isDeafAssist = false}) {
    // Fixed scale factor for the Deaf Assist item
    double scaleFactor = isDeafAssist ? 1.3 : 1.0; // Keep Deaf Assist item larger

    return BottomNavigationBarItem(
      icon: Transform.scale(
        scale: scaleFactor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _selectedIndex == index ? AppColors.primaryColor : Colors.grey),
            const SizedBox(height: 4), // Space between icon and label
            Text(
              label,
              style: TextStyle(
                color: _selectedIndex == index ? AppColors.primaryColor : Colors.grey,
                fontSize: 12, // Fixed font size for all items
              ),
            ),
          ],
        ),
      ),
      label: '', // Set label to empty, as we are using a custom widget above
    );
  }
}
