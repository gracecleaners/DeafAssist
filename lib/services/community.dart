import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Regions for automatic community addition
  final List<String> regions = ['Northern', 'Central', 'Eastern', 'Western'];

  // Add user to all regional communities upon account creation
  Future<void> addUserToRegionalCommunities(String userId) async {
    try {
      for (String region in regions) {
        // Create a regional community document if it doesn't exist
        DocumentReference regionCommRef =
            _firestore.collection('regional_communities').doc(region);

        // Add user to the members subcollection
        await regionCommRef
            .collection('members')
            .doc(userId)
            .set({'joined_at': FieldValue.serverTimestamp(), 'active': true});
      }
    } catch (e) {
      print('Error adding user to regional communities: $e');
      rethrow;
    }
  }

  // Create a district community (admin-only)
  Future<void> createDistrictCommunity(
      {required String districtName, required String adminId}) async {
    try {
      DocumentReference districtRef =
          await _firestore.collection('district_communities').add({
        'name': districtName,
        'created_by': adminId,
        'created_at': FieldValue.serverTimestamp(),
        'active': true
      });

      // Optional: Add admin as first member
      await districtRef
          .collection('members')
          .doc(adminId)
          .set({'role': 'admin', 'joined_at': FieldValue.serverTimestamp()});
    } catch (e) {
      print('Error creating district community: $e');
      rethrow;
    }
  }

  // Add a user to a specific district community
  Future<void> addUserToDistrictCommunity(
      {required String districtId, required String userId}) async {
    try {
      await _firestore
          .collection('district_communities')
          .doc(districtId)
          .collection('members')
          .doc(userId)
          .set({'joined_at': FieldValue.serverTimestamp(), 'role': 'member'});
    } catch (e) {
      print('Error adding user to district community: $e');
      rethrow;
    }
  }

  // Send a message to a community
  // Modify the sendMessageToCommunity method
  Future<void> sendMessageToCommunity(
      {required String communityId,
      required String communityType,
      required String message,
      String? replyToMessageId}) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      // Fetch user name from users collection
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      String userName = userDoc.exists
          ? userDoc['name']
          : (currentUser.displayName ?? 'Anonymous');

      String collectionPath = communityType == 'regional'
          ? 'regional_communities'
          : 'district_communities';

      await _firestore
          .collection(collectionPath)
          .doc(communityId)
          .collection('messages')
          .add({
        'text': message,
        'sender_id': currentUser.uid,
        'sender_name': userName,
        'timestamp': FieldValue.serverTimestamp(),
        'reply_to_id': replyToMessageId, // Optional reply reference
        'read_by': <String>[], // Track users who have read the message
        'is_read': false // Overall read status
      });
    } catch (e) {
      print('Error sending message to community: $e');
      rethrow;
    }
  }

  // Mark message as read for a specific user
  Future<void> markMessageAsRead(
      {required String communityId,
      required String communityType,
      required String messageId}) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      String collectionPath = communityType == 'regional'
          ? 'regional_communities'
          : 'district_communities';

      DocumentReference messageRef = _firestore
          .collection(collectionPath)
          .doc(communityId)
          .collection('messages')
          .doc(messageId);

      await messageRef.update({
        'read_by': FieldValue.arrayUnion([currentUser.uid]),
        'is_read': true
      });
    } catch (e) {
      print('Error marking message as read: $e');
      rethrow;
    }
  }

  // Retrieve messages for a specific community
  Stream<QuerySnapshot> getCommunityMessages(
      {required String communityId, required String communityType}) {
    String collectionPath = communityType == 'regional'
        ? 'regional_communities'
        : 'district_communities';

    return _firestore
        .collection(collectionPath)
        .doc(communityId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
