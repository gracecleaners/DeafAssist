import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/modals/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send message
  Future<void> sendMessage({
    required String receiverId, 
    required String content, 
    MessageType type = MessageType.text
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final message = Message(
      senderId: currentUser.uid,
      senderName: currentUser.displayName ?? 'Anonymous',
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now(),
      type: type,
    );

    // Create a unique chat room ID
    final chatRoomId = _generateChatRoomId(currentUser.uid, receiverId);

    // Add message to Firestore
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toMap());

    // Update last message in chat room
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .set({
          'participants': [currentUser.uid, receiverId],
          'lastMessage': content,
          'lastMessageTime': DateTime.now().toIso8601String(),
        }, SetOptions(merge: true));
  }

  // Get messages for a specific chat room
  Stream<List<Message>> getMessages(String otherUserId) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.empty();
    }

    final chatRoomId = _generateChatRoomId(currentUser.uid, otherUserId);

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => 
          snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList()
        );
  }

  // Generate a unique chat room ID for two users
  String _generateChatRoomId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0 
      ? '$userId1-$userId2' 
      : '$userId2-$userId1';
  }

  // Upload image for chat
  Future<String> uploadChatImage(File imageFile) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    final uploadTask = await storageRef.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }
}

