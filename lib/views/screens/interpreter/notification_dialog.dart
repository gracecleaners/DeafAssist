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
  List<InterpreterNotification> _notifications = [];
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
          .collection('interpreter_bookings')
          .where('interpreterId', isEqualTo: currentUser.uid)
          .where('status', isEqualTo: 'pending')
          .get();

      setState(() {
        _notifications = querySnapshot.docs
            .map((doc) => InterpreterNotification.fromFirestore(doc))
            .toList();
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

  Future<void> _handleBookingAction(InterpreterNotification notification, bool confirm) async {
    try {
      // Update booking status
      await FirebaseFirestore.instance
          .collection('interpreter_bookings')
          .doc(notification.id)
          .update({
        'status': confirm ? 'confirmed' : 'declined'
      });

      // If confirmed, send notification to user
      if (confirm) {
        await FirebaseFirestore.instance.collection('user_notifications').add({
          'userId': notification.userId,
          'title': 'Booking Confirmed',
          'message': 'Your interpreter booking for ${DateFormat('MMMM d, yyyy').format(notification.bookingDate)} has been confirmed.',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      // If declined, add the date back to interpreter's available dates
      if (!confirm) {
        final availabilitySnapshot = await FirebaseFirestore.instance
            .collection('interpreter_availability')
            .where('interpreterId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .get();

        if (availabilitySnapshot.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('interpreter_availability')
              .doc(availabilitySnapshot.docs.first.id)
              .update({
            'availableDates': FieldValue.arrayUnion([notification.bookingDate])
          });
        }
      }

      // Refresh notifications
      _fetchNotifications();
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
                          title: Text(notification.userName),
                          subtitle: Text(
                            DateFormat('EEEE, MMMM d, yyyy')
                                .format(notification.bookingDate),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: () => _handleBookingAction(notification, true),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () => _handleBookingAction(notification, false),
                              ),
                            ],
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