import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityService {
  final List<String> regions = [
    'Northern',
    'Southern',
    'Eastern',
    'Western',
    // Add more regions as needed
  ];

  Stream<QuerySnapshot> getCommunityMessages({
    required String communityId,
    required String communityType,
  }) {
    return FirebaseFirestore.instance
        .collection('communities')
        .doc(communityType)
        .collection(communityId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessageToCommunity({
    required String communityId,
    required String communityType,
    required String message,
    DocumentSnapshot? replyingTo,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    Map<String, dynamic> messageData = {
      'sender_id': currentUser.uid,
      'sender_name': currentUser.displayName ?? 'Anonymous',
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
      'is_read': false,
    };

    if (replyingTo != null) {
      messageData['replying_to'] = {
        'sender_id': replyingTo['sender_id'],
        'text': replyingTo['text'],
      };
    }

    await FirebaseFirestore.instance
        .collection('communities')
        .doc(communityType)
        .collection(communityId)
        .add(messageData);
  }

  Future<void> markMessagesAsRead({
    required String communityId,
    required String communityType,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    final unreadMessages = await FirebaseFirestore.instance
        .collection('communities')
        .doc(communityType)
        .collection(communityId)
        .where('is_read', isEqualTo: false)
        .where('sender_id', isNotEqualTo: currentUser.uid)
        .get();

    for (var doc in unreadMessages.docs) {
      await doc.reference.update({'is_read': true});
    }
  }

  Stream<int> getUnreadMessageCount({
    required String communityId,
    required String communityType,
  }) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('communities')
        .doc(communityType)
        .collection(communityId)
        .where('is_read', isEqualTo: false)
        .where('sender_id', isNotEqualTo: currentUser?.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}