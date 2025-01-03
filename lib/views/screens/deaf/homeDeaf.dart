import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/modals/category.dart';
import 'package:deafassist/services/auth_service.dart';
import 'package:deafassist/views/screens/deaf/comm.dart';
import 'package:deafassist/views/screens/deaf/resource_main.dart';
import 'package:deafassist/views/screens/deaf/upcoming_events.dart';
import 'package:deafassist/views/screens/deaf/view_interpreters.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomeDeaf extends StatefulWidget {
  const HomeDeaf({super.key});

  @override
  _HomeDeafState createState() => _HomeDeafState();
}

class _HomeDeafState extends State<HomeDeaf> {
  bool showUpdates = true;
  int unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    _fetchUnreadNotificationsCount();
  }

  Future<void> _fetchUnreadNotificationsCount() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('user_notifications')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      // Count notifications where read is explicitly false or not set
      int unreadCount = querySnapshot.docs.where((doc) {
        final data = doc.data();
        return data['read'] != true; // Consider notification unread if read isn't explicitly true
      }).length;

      setState(() {
        unreadNotifications = unreadCount;
      });
    } catch (e) {
      print('Error fetching unread notifications count: $e');
    }
  }

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
                unreadCount: unreadNotifications,
                onTabChanged: (bool isUpdates) {
                  setState(() {
                    showUpdates = isUpdates;
                    if (!isUpdates) {
                      unreadNotifications = 0;
                    }
                  });
                },
              ),
              showUpdates ? const UpdatesBody() : NotificationsBody(
                onNotificationsRead: () {
                  setState(() {
                    unreadNotifications = 0;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabSelector extends StatelessWidget {
  final bool showUpdates;
  final int unreadCount;
  final Function(bool) onTabChanged;

  const TabSelector({
    super.key,
    required this.showUpdates,
    required this.unreadCount,
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
          SizedBox(width: 40),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Notifications",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: !showUpdates ? FontWeight.bold : FontWeight.normal,
                        color: !showUpdates ? AppColors.primaryColor : Colors.grey,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      SizedBox(width: 5),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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

class NotificationsBody extends StatefulWidget {
  final VoidCallback onNotificationsRead;

  const NotificationsBody({
    Key? key,
    required this.onNotificationsRead,
  }) : super(key: key);

  @override
  _NotificationsBodyState createState() => _NotificationsBodyState();
}

class _NotificationsBodyState extends State<NotificationsBody> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('user_notifications')
          .where('userId', isEqualTo: currentUser.uid)
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        _notifications = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return {
            'id': doc.id,
            'read': data['read'] ?? false, // Provide default value for read
            'title': data['title'] ?? 'Notification',
            'message': data['message'] ?? '',
            'timestamp': data['timestamp'] ?? Timestamp.now(),
            'userId': data['userId'] ?? '',
          };
        }).toList();
        _isLoading = false;
      });

      // Mark notifications as read
      await _markNotificationsAsRead(querySnapshot.docs);
      widget.onNotificationsRead();
    } catch (e) {
      print('Error in _fetchNotifications: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading notifications: $e')),
        );
      }
    }
  }

  Future<void> _markNotificationsAsRead(List<QueryDocumentSnapshot> docs) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      
      for (var doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        // Only update if not already read
        if (data['read'] != true) {
          batch.update(doc.reference, {'read': true});
        }
      }

      await batch.commit();
    } catch (e) {
      print('Error in _markNotificationsAsRead: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_notifications.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No notifications',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _notifications.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.grey.shade300,
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        final isDeclined = notification['message']?.toString().contains('declined') ?? false;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: Text(
            notification['title'] ?? 'Notification',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification['message'] ?? '',
                style: TextStyle(
                  color: isDeclined ? Colors.red : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('MMM d, HH:mm').format(
                  (notification['timestamp'] as Timestamp).toDate(),
                ),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing: isDeclined
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('😢', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 4),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('😊', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 4),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
        );
      },
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