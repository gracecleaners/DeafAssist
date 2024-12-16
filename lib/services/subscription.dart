import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/modals/subscription.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUserRole() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return '';

      var userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      return userDoc.data()?['role'] ?? '';
    } catch (e) {
      print('Error fetching user role: $e');
      return '';
    }
  }

  Future<double> getSubscriptionAmount() async {
    String userRole = await getUserRole();
    return userRole == 'deaf' ? 100000.0 : 50000.0;
  }

  Future<bool> checkUserSubscription() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      var subscriptionDoc = await _firestore
          .collection('subscriptions')
          .doc(currentUser.uid)
          .get();

      if (subscriptionDoc.exists) {
        SubscriptionModel subscription = SubscriptionModel.fromMap(
          subscriptionDoc.data() as Map<String, dynamic>
        );
        
        // Check if subscription is active within 1 year
        return subscription.isActive && 
               DateTime.now().difference(subscription.purchaseDate).inDays <= 365;
      }

      return false;
    } catch (e) {
      print('Error checking subscription: $e');
      return false;
    }
  }

  Future<void> createSubscription() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      SubscriptionModel newSubscription = SubscriptionModel(
        userId: currentUser.uid,
        purchaseDate: DateTime.now(),
        isActive: true,
      );

      await _firestore
          .collection('subscriptions')
          .doc(currentUser.uid)
          .set(newSubscription.toMap());
    } catch (e) {
      print('Error creating subscription: $e');
    }
  }
}