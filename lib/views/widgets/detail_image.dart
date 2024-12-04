import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase import
import 'package:deafassist/views/widgets/curve_mage_side.dart';
import 'package:flutter/material.dart';

class ProductDetailImages extends StatelessWidget {
  final String interpreterId; // Interpreter ID to fetch details from Firebase

  const ProductDetailImages({super.key, required this.interpreterId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<DocumentSnapshot>(
      // Fetch interpreter details from Firestore using the interpreterId
      future: FirebaseFirestore.instance.collection('interpreters').doc(interpreterId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator while data is being fetched
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Handle any errors
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('Interpreter not found.'));
        }

        var interpreterData = snapshot.data!.data() as Map<String, dynamic>;
        String profileImageUrl = interpreterData['profileImageUrl'] ?? ''; // Get profile image URL or empty string if not found

        return ClipPath(
          clipper: CurveImageSide(),
          child: Align(
            alignment: Alignment.topCenter,
            child: Center(
              child: Hero(
                tag: profileImageUrl,
                child: Image(
                  fit: BoxFit.cover,
                  height: size.height * 0.5,
                  width: size.width,
                  image: profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl) // Use NetworkImage for remote URLs
                      : const AssetImage('assets/default_profile.png'), // Default image if URL is empty
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
