import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, voice }

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool seen;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.seen,
  });

  factory Message.fromMap(Map<String, dynamic> data, String documentId) {
    return Message(
      id: documentId,
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      content: data['content'],
      type: MessageType.values[data['type']],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      seen: data['seen'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type.index,
      'timestamp': timestamp,
      'seen': seen,
    };
  }
}
