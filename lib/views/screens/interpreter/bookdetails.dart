import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

            // Dynamic Booking Name
            _buildDetailRow('Event/Booking Name', 
              notification['type'] == 'booking' 
                ? 'Physical Meetup'
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