import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/services/community.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String region;

  const ChatScreen({super.key, required this.region});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final CommunityService _communityService = CommunityService();
  final TextEditingController _messageController = TextEditingController();
  DocumentSnapshot? _replyingTo;

  @override
  void initState() {
    super.initState();
    _communityService.markMessagesAsRead(
      communityId: widget.region,
      communityType: 'regional',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.region, style: GoogleFonts.ubuntu()),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          // Messages Stream
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _communityService.getCommunityMessages(
                  communityId: widget.region, communityType: 'regional'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _replyingTo = message;
                        });
                      },
                      child: _buildMessageItem(message),
                    );
                  },
                );
              },
            ),
          ),

          // Replying to message
          if (_replyingTo != null)
            Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Replying to:',
                          style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _replyingTo!['text'],
                          style: GoogleFonts.ubuntu(
                            color: Colors.grey.shade800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _replyingTo = null;
                      });
                    },
                  ),
                ],
              ),
            ),

          // Message Input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Send a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _communityService.sendMessageToCommunity(
                        communityId: widget.region,
                        communityType: 'regional',
                        message: _messageController.text,
                        replyingTo: _replyingTo,
                      );
                      _messageController.clear();
                      setState(() {
                        _replyingTo = null;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot message) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isCurrentUser = message['sender_id'] == currentUserId;

    // Safely retrieve timestamp or use a fallback
    final timestamp = (message['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
    final formattedDate = _formatDate(timestamp);

    final messageData = message.data() as Map<String, dynamic>;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(message['sender_id'])
          .get(),
      builder: (context, userSnapshot) {
        // Default to sender_name from message if user document not found
        String senderName = userSnapshot.hasData && userSnapshot.data!.exists 
            ? userSnapshot.data!['name'] 
            : (message['sender_name'] ?? 'Anonymous');

        return Align(
          alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCurrentUser 
                ? AppColors.primaryColor.withOpacity(0.2) 
                : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (messageData.containsKey('replying_to'))
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      messageData['replying_to']['text'],
                      style: GoogleFonts.ubuntu(color: Colors.grey.shade800),
                    ),
                  ),
                Text(
                  senderName,
                  style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  messageData['text'],
                  style: GoogleFonts.ubuntu(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    formattedDate,
                    style: GoogleFonts.ubuntu(
                      color: Colors.black45,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today, ${DateFormat('hh:mm a').format(date)}';
    } else if (difference == 1) {
      return 'Yesterday, ${DateFormat('hh:mm a').format(date)}';
    } else {
      return DateFormat('MMM dd, yyyy, hh:mm a').format(date);
    }
  }
}