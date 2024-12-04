import 'package:cloud_firestore/cloud_firestore.dart';

class InterpreterAvailability {
  final String? id;
  final String interpreterId;
  final List<DateTime> availableDates;
  final Timestamp createdAt;

  InterpreterAvailability({
    this.id,
    required this.interpreterId,
    required this.availableDates,
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'interpreterId': interpreterId,
      'availableDates': availableDates.map((date) => Timestamp.fromDate(date)).toList(),
      'createdAt': createdAt,
    };
  }

  // Create from Firestore document
  factory InterpreterAvailability.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return InterpreterAvailability(
      id: snapshot.id,
      interpreterId: data['interpreterId'],
      availableDates: (data['availableDates'] as List)
          .map((timestamp) => (timestamp as Timestamp).toDate())
          .toList(),
      createdAt: data['createdAt'],
    );
  }
}