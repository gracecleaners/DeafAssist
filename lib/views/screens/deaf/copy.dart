import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/modals/category.dart';
import 'package:deafassist/services/auth_service.dart';
import 'package:deafassist/views/screens/deaf/comm.dart';
import 'package:deafassist/views/screens/deaf/notification.dart';
import 'package:deafassist/views/screens/deaf/resource_main.dart';
import 'package:deafassist/views/screens/deaf/upcoming_events.dart';
import 'package:deafassist/views/screens/deaf/view_interpreters.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class HomeDeaf extends StatefulWidget {
  const HomeDeaf({super.key});

  @override
  _HomeDeafState createState() => _HomeDeafState();
}

class _HomeDeafState extends State<HomeDeaf> {
  bool showUpdates = true;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(),
              TabSelector(
                showUpdates: showUpdates,
                onTabChanged: (bool isUpdates) {
                  setState(() {
                    showUpdates = isUpdates;
                  });
                },
              ),
              showUpdates ? const UpdatesBody() : const NotificationsBody(),
            ],
          ),
        ),
      ),
    );
  }
}

class TabSelector extends StatelessWidget {
  final bool showUpdates;
  final Function(bool) onTabChanged;

  const TabSelector({
    super.key,
    required this.showUpdates,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.04;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: showUpdates ? AppColors.primaryColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  "Updates",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: showUpdates ? FontWeight.bold : FontWeight.normal,
                    color: showUpdates ? AppColors.primaryColor : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 40,),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: !showUpdates ? AppColors.primaryColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "Notifications",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: !showUpdates ? FontWeight.bold : FontWeight.normal,
                        color: !showUpdates ? AppColors.primaryColor : Colors.grey,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      height: 15,
                      width: 15,
                      // color: Colors.red,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red
                      ),
                      child: Text("3", style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdatesBody extends StatelessWidget {
  const UpdatesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Text(
        "Notifications",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    List<Category> categoryList = [
      Category(
        name: 'Interpreters',
        thumbnail: 'assets/images/gath.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ViewInterpreters(),
            ),
          );
        },
      ),
      Category(
        name: 'Resources',
        thumbnail: 'assets/images/res.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Resources(),
            ),
          );
        },
      ),
      Category(
        name: 'Community Support',
        thumbnail: 'assets/images/group.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainHome(),
            ),
          );
        },
      ),
      Category(
        name: 'Events',
        thumbnail: 'assets/images/event.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UpcomingEvents(),
            ),
          );
        },
      ),
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.04;

    return Column(
      children: [
        const HorizontalImageScroll(imageUrls: [
          'assets/images/new.png',
          'assets/images/newpdf.png',
          'assets/images/okumu.png',
          'assets/images/new.png',
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Our Services",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 24,
          ),
          itemBuilder: (context, index) {
            return CategoryCard(
              category: categoryList[index],
            );
          },
          itemCount: categoryList.length,
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenWidth * 0.03;

    final double imageHeight = screenHeight * 0.15;
    final double imageWidth = screenWidth * 0.35;

    return GestureDetector(
      onTap: () => category.onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 4.0,
              spreadRadius: .05,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Flexible(
              child: Center(
                child: Image.asset(
                  category.thumbnail,
                  height: imageHeight,
                  width: imageWidth,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final AuthService _authService = AuthService();
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc.data()?['name'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.05;
    double fontSize1 = screenWidth * 0.07;

    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              width: double.infinity,
              color: AppColors.primaryColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getGreeting(),
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize1,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewInterpreters(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.9,
                      40,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Book an Interpreter",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalImageScroll extends StatefulWidget {
  final List<String> imageUrls;

  const HorizontalImageScroll({super.key, required this.imageUrls});

  @override
  _HorizontalImageScrollState createState() => _HorizontalImageScrollState();
}

class _HorizontalImageScrollState extends State<HorizontalImageScroll> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _currentPage++;
      if (_currentPage >= widget.imageUrls.length) {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.05;
    double fontSize1 = screenWidth * 0.03;
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.35,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length * 100,
        itemBuilder: (context, index) {
          int actualIndex = index % widget.imageUrls.length;
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    ),
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(widget.imageUrls[actualIndex]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.2),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 5),
                child: Text(
                  "Sign Talk",
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 40, right: 10),
                child: Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSize1,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 100),
                child: ElevatedButton(
                  onPressed: () {
                    // Button action goes here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Read More",
                    style: TextStyle(
                      fontSize: fontSize1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}