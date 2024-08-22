import 'package:cloud_firestore/cloud_firestore.dart';

class Interpreter {
  final String fullName;
  final String email;
  final String telephone;
  final int yearsOfExperience;
  final String district;
  final String linkedin;
  final String twitter;
  final String currentEmployer;
  final String aboutMe;
  final String profileImageUrl;
  final bool isAvailable; // Add this property

  Interpreter({
    required this.fullName,
    required this.email,
    required this.telephone,
    required this.yearsOfExperience,
    required this.district,
    required this.linkedin,
    required this.twitter,
    required this.currentEmployer,
    required this.aboutMe,
    required this.profileImageUrl,
    required this.isAvailable, // Add this property to the constructor
  });

  // Method to create an Interpreter instance from Firestore data
  factory Interpreter.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Interpreter(
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      telephone: data['telephone'] ?? '',
      yearsOfExperience: data['yearsOfExperience'] ?? 0,
      district: data['district'] ?? '',
      linkedin: data['linkedin'] ?? '',
      twitter: data['twitter'] ?? '',
      currentEmployer: data['currentEmployer'] ?? '',
      aboutMe: data['aboutMe'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      isAvailable: data['isAvailable'] ?? false, // Default to false if not specified
    );
  }

  // Method to convert Interpreter instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'telephone': telephone,
      'yearsOfExperience': yearsOfExperience,
      'district': district,
      'linkedin': linkedin,
      'twitter': twitter,
      'currentEmployer': currentEmployer,
      'aboutMe': aboutMe,
      'profileImageUrl': profileImageUrl,
      'isAvailable': isAvailable,
    };
  }
}
