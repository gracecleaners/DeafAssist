import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/modals/category.dart';
import 'package:deafassist/services/auth_service.dart';
import 'package:deafassist/views/screens/deaf/comm.dart';
import 'package:deafassist/views/screens/deaf/resource_main.dart';
import 'package:deafassist/views/screens/deaf/upcoming_events.dart';
import 'package:deafassist/views/screens/deaf/view_interpreters.dart';
import 'package:deafassist/views/screens/interpreter/notification_dialog.dart';
import 'package:deafassist/views/screens/interpreter/schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class HomeInterpreter extends StatefulWidget {
  const HomeInterpreter({super.key});

  @override
  _HomeInterpreterState createState() => _HomeInterpreterState();
}

class _HomeInterpreterState extends State<HomeInterpreter> {
  // Initialize your AuthService
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
              const Body(),
            ],
          ),
        ),
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
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 20), // Add some horizontal padding
          child: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              "Updates",
              textAlign: TextAlign
                  .start, // This ensures left alignment within its space
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const HorizontalImageScroll(imageUrls: [
          'assets/images/new.png',
          'assets/images/newpdf.png',
          'assets/images/okumu.png',
          'assets/images/new.png',
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 20), // Add some horizontal padding
          child: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              "Our Services",
              textAlign: TextAlign
                  .start, // This ensures left alignment within its space
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
  final AuthService _authService = AuthService();

  CustomAppBar({super.key});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  int _pendingBookingsCount = 0;
  StreamSubscription? _bookingsSubscription;

  @override
  void initState() {
    super.initState();
    _setupBookingNotificationListener();
  }

  void _setupBookingNotificationListener() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    _bookingsSubscription = FirebaseFirestore.instance
        .collection('interpreter_bookings')
        .where('interpreterId', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _pendingBookingsCount = snapshot.docs.length;
      });
    });
  }

  @override
  void dispose() {
    _bookingsSubscription?.cancel();
    super.dispose();
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
          // Upper part with primary color
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              width: double.infinity,
              color: AppColors.primaryColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            getGreeting(),
                            style: TextStyle(
                                fontSize: fontSize,
                                color: Colors.white),
                          ),
                        ),
                        Text(
                          ", Oscarlincoln",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize1,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // Notification Icon with Badge
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const NotificationDialog(),
                          );
                        },
                      ),
                      if (_pendingBookingsCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$_pendingBookingsCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Rest of the existing AppBar code remains the same
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
                        builder: (context) => const ScheduleAvailabilityScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.withOpacity(0.7),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Schedule Availability",
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
  final List<String> imageUrls; // List of image URLs or asset paths

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

    // Timer to automatically scroll every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _currentPage++;
      if (_currentPage >= widget.imageUrls.length) {
        _currentPage = 0; // Reset to first page
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
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.05;
    double fontSize1 = screenWidth * 0.03;
    return SizedBox(
      height: MediaQuery.of(context).size.width *
          0.35, // Set the height of the container
      child: PageView.builder(
        controller: _pageController,
        itemCount:
            widget.imageUrls.length * 100, // Large number to simulate looping
        itemBuilder: (context, index) {
          // Calculate the actual index from the infinite scroll index
          int actualIndex = index % widget.imageUrls.length;
          return Stack(
            // Use Stack to layer gradient over image
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 8), // Reduced horizontal margin
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.5), // Dark overlay color
                      Colors.transparent, // Gradually transparent
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(widget.imageUrls[
                        actualIndex]), // Use AssetImage for local images
                    fit: BoxFit.cover, // Cover the entire container
                  ),
                ),
              ),
              // Gradient overlay
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7), // Dark overlay color
                      Colors.black.withOpacity(0.2), // Gradually transparent
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
                      fontWeight: FontWeight.bold),
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
                      fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 100),
                child: ElevatedButton(
                  onPressed: () {
                    // Button action goes here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10), // Button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Read More",
                    style: TextStyle(
                      fontSize: fontSize1,
                      color: Colors.white, // Button text color
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
