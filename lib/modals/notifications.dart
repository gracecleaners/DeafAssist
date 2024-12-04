import 'package:cloud_firestore/cloud_firestore.dart';

class InterpreterNotification {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime bookingDate;
  final String status;
  final Timestamp timestamp;

  InterpreterNotification({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.bookingDate,
    required this.status,
    required this.timestamp,
  });

  factory InterpreterNotification.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InterpreterNotification(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown User',
      userEmail: data['userEmail'] ?? 'No email',
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}