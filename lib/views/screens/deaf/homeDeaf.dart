import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/views/screens/deaf/copy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HomeDeaf extends StatefulWidget {
  const HomeDeaf({super.key});

  @override
  _HomeDeafState createState() => _HomeDeafState();
}

class _HomeDeafState extends State<HomeDeaf> {
  bool showUpdates = true;
  int unreadNotifications = 0;
  late Stream<QuerySnapshot> _notificationsStream;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _fetchUnreadNotificationsCount();
    _listenToNewNotifications();
  }

  void _initializeNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _notificationsStream = FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: user.uid)
          .where('isRead', isEqualTo: false)
          .snapshots();
    }
  }

  void _listenToNewNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Listen to interpreter bookings
      FirebaseFirestore.instance
          .collection('interpreter_bookings')
          .where('userId', isEqualTo: user.uid)
          .where('read', isEqualTo: false)
          .snapshots()
          .listen((snapshot) {
        _updateNotificationCount(snapshot.docs.length);
      });

      // Listen to online interpretations
      FirebaseFirestore.instance
          .collection('online_interpretations')
          .where('userId', isEqualTo: user.uid)
          .where('read', isEqualTo: false)
          .snapshots()
          .listen((snapshot) {
        _updateNotificationCount(snapshot.docs.length);
      });
    }
  }

  void incrementNotificationCount() {
    if (mounted) {
      setState(() {
        unreadNotifications++;
      });
    }
  }

  Future<void> _fetchUnreadNotificationsCount() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // Get reference to the user's notification counter
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          unreadNotifications = userDoc.data()?['unreadNotifications'] ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching unread notifications count: $e');
    }
  }

  void _showNotification(String title, String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(message, style: TextStyle(color: Colors.white)),
          ],
        ),
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue.shade900,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  Future<void> _updateNotificationCount(int newCount) async {
    if (!mounted) return;
    
    setState(() {
      // Only update if we're on the Updates tab
      if (showUpdates) {
        unreadNotifications = newCount;
      }
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({
          'unreadNotifications': newCount,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error updating notification count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBar(),
                  TabSelector(
                    showUpdates: showUpdates,
                    unreadCount: showUpdates ? unreadNotifications : 0,
                    onTabChanged: (bool isUpdates) {
                      setState(() {
                        showUpdates = isUpdates;
                        if (!isUpdates) {
                          // Reset notification count when switching to notifications tab
                          unreadNotifications = 0;
                          _updateNotificationCount(0);
                        } else {
                          // Refresh count when switching back to updates tab
                          _fetchUnreadNotificationsCount();
                        }
                      });
                    },
                  ),
                  showUpdates 
                    ? const UpdatesBody() 
                    : NotificationsBody(
                        onNotificationsRead: () {
                          setState(() {
                            unreadNotifications = 0;
                          });
                          // Update the count in Firestore
                          _updateNotificationCount(0);
                        },
                      ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _notificationsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final notifications = snapshot.data!.docs;
                    for (var doc in notifications) {
                      final data = doc.data() as Map<String, dynamic>;
                      _showNotification(data['title'], data['message']);
                      // Mark notification as read
                      doc.reference.update({'isRead': true});
                    }
                  });
                }
                return SizedBox.shrink();
              },
            ),
          ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: "Updates",
              isSelected: showUpdates,
              onTap: () => onTabChanged(true),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: _TabButton(
              title: "Notifications",
              isSelected: !showUpdates,
              unreadCount: unreadCount,
              onTap: () => onTabChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final int? unreadCount;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
            if (unreadCount != null && unreadCount! > 0) ...[
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
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

      final batch = FirebaseFirestore.instance.batch();

      // Fetch and mark bookings as read
      final bookingsQuery = await FirebaseFirestore.instance
          .collection('interpreter_bookings')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      List<Map<String, dynamic>> bookingNotifications = bookingsQuery.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        bool isPending = data['status'] == 'pending';
        if (isPending) {
          batch.update(doc.reference, {'read': true});
        }
        
        return {
          'id': doc.id,
          'type': 'booking',
          'title': 'Interpreter Booking ${_getStatusText(data['status'])}',
          'message': 'Booking for ${DateFormat('MMMM d, yyyy').format((data['bookingDate'] as Timestamp).toDate())}',
          'timestamp': data['timestamp'] ?? Timestamp.now(),
          'status': data['status'],
        };
      }).toList();

      // Fetch and mark online interpretations as read
      final onlineInterpretationsQuery = await FirebaseFirestore.instance
          .collection('online_interpretations')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      List<Map<String, dynamic>> onlineNotifications = onlineInterpretationsQuery.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        bool isPending = data['status'] == 'Pending';
        if (isPending) {
          batch.update(doc.reference, {'read': true});
        }

        return {
          'id': doc.id,
          'type': 'online_interpretation',
          'title': 'Online Interpretation ${_getStatusText(data['status'])}',
          'message': 'Session for ${data['eventName']} on ${DateFormat('MMMM d, yyyy').format((data['eventDate'] as Timestamp).toDate())}',
          'timestamp': data['bookingDate'] ?? Timestamp.now(),
          'status': data['status'],
        };
      }).toList();

      await batch.commit();

      List<Map<String, dynamic>> allNotifications = [...bookingNotifications, ...onlineNotifications];
      allNotifications.sort((a, b) => (b['timestamp'] as Timestamp).compareTo(a['timestamp'] as Timestamp));

      setState(() {
        _notifications = allNotifications;
        _isLoading = false;
      });

      widget.onNotificationsRead();
    } catch (e) {
      print('Error in _fetchNotifications: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading notifications')),
        );
      }
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'declined':
        return 'Declined';
      default:
        return 'Updated';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'declined':
        return Colors.red;
      default:
        return Colors.blue;
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
      ),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        final status = notification['status'].toString().toLowerCase();
        
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  notification['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(status),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getStatusText(status),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                notification['message'],
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                DateFormat('MMM d, yyyy HH:mm').format(
                  (notification['timestamp'] as Timestamp).toDate(),
                ),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}