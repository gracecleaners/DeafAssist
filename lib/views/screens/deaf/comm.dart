import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/views/screens/deaf/district.dart';
import 'package:deafassist/views/screens/deaf/region.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  /// List of Tab Bar Item
  List<String> items = [
    "Regional Communities",
    "District Communities",
  ];

  /// List of icons for Bottom Navigation Bar
  List<IconData> icons = [
    Icons.call,
    Icons.chat_bubble,
  ];

  /// List of pages for each tab
  List<Widget> pages = [
    // const RegionScreen(),
    // const DistrictScreen(),
  ];

  int current = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          items[current],
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios, color: AppColors.backgroundColor,)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          )
        ],
      ),
      body: PageView.builder(
        itemCount: pages.length,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return pages[index];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(items.length, (index) {
          return BottomNavigationBarItem(
            icon: Icon(icons[index]),
            label: items[index],
          );
        }),
        currentIndex: current,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        onTap: (index) {
          setState(() {
            current = index;
          });
          pageController.animateToPage(
            current,
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}
