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
        .update({
      'status': confirm ? 'confirmed' : 'declined'
    });

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
        content: Text(
          confirm 
            ? 'You have confirmed the booking' 
            : 'You have declined the booking'
        ),
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
      title: const Text('Booking Notifications'),
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
                        return ListTile(
                          onTap: () => _navigateToBookingDetails(notification),
                          title: notification['type'] == 'booking'
                              ? Text(notification['data']['userName'] ?? 'Unknown User')
                              : Text(notification['data']['eventName'] ?? 'Unknown Event'),
                          subtitle: notification['type'] == 'booking'
                              ? Text(DateFormat('EEEE, MMMM d, yyyy')
                                  .format((notification['data']['bookingDate'] as Timestamp).toDate()))
                              : Text(
                                  'Date: ${DateFormat('EEEE, MMMM d, yyyy').format((notification['data']['eventDate'] as Timestamp).toDate())}\n'
                                  'Time: ${notification['data']['eventTime']}\n'
                                  'Duration: ${notification['data']['duration']} minutes'
                                ),
                        );
                      },
                    ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Type (In-Person or Online)
            Text(
              notification['type'] == 'booking' 
                ? 'In-Person Interpreter Booking' 
                : 'Online Interpretation',
              // style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),

            // Common Details
            _buildDetailRow('Event/Booking Name', 
              notification['type'] == 'booking' 
                ? notification['data']['userName'] ?? 'Unknown User'
                : notification['data']['eventName'] ?? 'Unknown Event'
            ),

            // Date Details
            _buildDetailRow('Date', 
              notification['type'] == 'booking'
                ? DateFormat('EEEE, MMMM d, yyyy').format((notification['data']['bookingDate'] as Timestamp).toDate())
                : DateFormat('EEEE, MMMM d, yyyy').format((notification['data']['eventDate'] as Timestamp).toDate())
            ),

            // Additional Details based on booking type
            if (notification['type'] == 'booking')
              _buildDetailRow('Additional Info', 
                notification['data'].containsKey('location') 
                  ? notification['data']['location']
                  : 'No additional information available'
              ),

            if (notification['type'] == 'online_interpretation') ...[
              _buildDetailRow('Time', notification['data']['eventTime']),
              _buildDetailRow('Duration', '${notification['data']['duration']} minutes'),
              _buildDetailRow('Platform', notification['data']['platform'] ?? 'Not specified'),
            ],

            Spacer(),

            // Confirm and Decline Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Confirm'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onDecline,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Decline'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
}