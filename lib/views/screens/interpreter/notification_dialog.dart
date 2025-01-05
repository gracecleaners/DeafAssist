import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/modals/notifications.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationDialog extends StatefulWidget {
  const NotificationDialog({Key? key}) : super(key: key);

  @override
  _NotificationDialogState createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  List<dynamic> _notifications = [];
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

      // Fetch interpreter bookings
      final bookingQuerySnapshot = await FirebaseFirestore.instance
          .collection('interpreter_bookings')
          .where('interpreterId', isEqualTo: currentUser.uid)
          .where('status', isEqualTo: 'pending')
          .get();

      // Fetch online interpretations
      final onlineInterpretationQuerySnapshot = await FirebaseFirestore.instance
          .collection('online_interpretations')
          .where('interpreterId', isEqualTo: currentUser.uid)
          .where('status', isEqualTo: 'Pending')
          .get();

      setState(() {
        _notifications = [
          ...bookingQuerySnapshot.docs.map((doc) => {
                'type': 'booking',
                'data': doc.data(), // Changed from InterpreterNotification
                'docId': doc.id
              }),
          ...onlineInterpretationQuerySnapshot.docs.map((doc) => {
                'type': 'online_interpretation',
                'data': doc.data(),
                'docId': doc.id
              })
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading notifications: $e')),
      );
    }
  }

  void _navigateToBookingDetails(dynamic notification) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookingDetailsScreen(
          notification: notification,
          onConfirm: () => _handleBookingAction(notification, true),
          onDecline: () => _handleBookingAction(notification, false),
        ),
      ),
    );
  }

  Future<void> _handleBookingAction(dynamic notification, bool confirm) async {
    try {
      String collectionPath = '';
      String userId = '';
      String eventName = '';
      DateTime eventDate;
      String notificationMessage = '';

      if (notification['type'] == 'booking') {
        collectionPath = 'interpreter_bookings';
        userId = notification['data']['userId'];
        eventName = 'Interpreter Booking';
        eventDate = (notification['data']['bookingDate'] as Timestamp).toDate();
        notificationMessage = confirm
            ? 'Your meet up booking has been confirmed'
            : 'Your meet up booking has been declined';
      } else {
        collectionPath = 'online_interpretations';
        userId = notification['data']['userId'];
        eventName = notification['data']['eventName'];
        eventDate = (notification['data']['eventDate'] as Timestamp).toDate();
        notificationMessage = confirm
            ? 'Your online interpretation booking has been confirmed'
            : 'Your online interpretation booking has been declined';
      }

      // Update booking status
      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(notification['docId'])
          .update({'status': confirm ? 'confirmed' : 'declined'});

      // Send notification to user for both confirmed and declined bookings
      await FirebaseFirestore.instance.collection('user_notifications').add({
        'userId': userId,
        'title': confirm ? 'Booking Confirmed' : 'Booking Declined',
        'message': notificationMessage,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Refresh notifications
      _fetchNotifications();

      // Show SnackBar based on confirmation status
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(confirm
              ? 'You have confirmed the booking'
              : 'You have declined the booking'),
          backgroundColor: confirm ? Colors.green : Colors.red,
        ),
      );

      // Pop back to previous screen if we're in the details screen
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing booking: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
  title: const Text(
    'Booking Notifications',
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  content: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: _notifications.isEmpty
              ? const Center(child: Text('No pending bookings'))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    final isBooking = notification['type'] == 'booking';
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => _navigateToBookingDetails(notification),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Booking Type Indicator
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isBooking ? 'In-Person' : 'Online',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              
                              // Title
                              Text(
                                isBooking
                                    ? notification['data']['userName'] ?? 'Unknown User'
                                    : notification['data']['eventName'] ?? 'Unknown Event',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              
                              // Date and Time Information
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      DateFormat('EEEE, MMMM d, yyyy').format(
                                        (isBooking
                                          ? notification['data']['bookingDate']
                                          : notification['data']['eventDate'] as Timestamp).toDate()
                                      ),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              // Additional Details for Online Interpretation
                              if (!isBooking) ...[
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      notification['data']['eventTime'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Icon(
                                      Icons.timer,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${notification['data']['duration']} minutes',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
  actions: [
    TextButton(
      onPressed: () => Navigator.of(context).pop(),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: const Text(
        'Close',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ],
);
  }
}

class BookingDetailsScreen extends StatelessWidget {
  final dynamic notification;
  final VoidCallback onConfirm;
  final VoidCallback onDecline;

  const BookingDetailsScreen({
    Key? key,
    required this.notification,
    required this.onConfirm,
    required this.onDecline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPhysicalBooking = notification['type'] == 'booking';
    final bookingDate = isPhysicalBooking
        ? (notification['data']['bookingDate'] as Timestamp).toDate()
        : (notification['data']['eventDate'] as Timestamp).toDate();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Airbnb-style collapsing app bar
          SliverAppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 25,)),
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Booking Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: Container(
                color: AppColors.primaryColor,
                child: Center(
                  child: Icon(
                    isPhysicalBooking ? Icons.person : Icons.video_call,
                    size: 80,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Booking Type Header
                  Text(
                    isPhysicalBooking
                        ? 'In-Person Interpreter Booking'
                        : 'Online Interpretation',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 24),

                  // User/Event Name Section
                  _buildSection(
                    context,
                    icon: Icons.person_outline,
                    title: isPhysicalBooking ? 'User' : 'Event',
                    content: Text(
                      isPhysicalBooking
                          ? notification['data']['userName'] ?? 'Unknown User'
                          : notification['data']['eventName'] ??
                              'Unknown Event',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),

                  // Date and Time Section
                  _buildSection(
                    context,
                    icon: Icons.calendar_today,
                    title: 'Date & Time',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE, MMMM d, yyyy').format(bookingDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (!isPhysicalBooking) ...[
                          SizedBox(height: 8),
                          Text(
                            notification['data']['eventTime'],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Duration: ${notification['data']['duration']} minutes',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Location/Platform Section
                  _buildSection(
                    context,
                    icon: isPhysicalBooking ? Icons.location_on : Icons.laptop,
                    title: isPhysicalBooking ? 'Location' : 'Platform Details',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isPhysicalBooking)
                          Text(
                            notification['data'].containsKey('location')
                                ? notification['data']['location']
                                : 'No location specified',
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        else ...[
                          Text(
                            notification['data']['platform'] ??
                                'Platform not specified',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onDecline,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Decline',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: Theme.of(context).primaryColor),
              SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, top: 8.0),
            child: content,
          ),
        ],
      ),
    );
  }
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
