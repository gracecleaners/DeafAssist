import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/services/community.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegionalCommunityScreen extends StatefulWidget {
  const RegionalCommunityScreen({super.key});

  @override
  State<RegionalCommunityScreen> createState() =>
      _RegionalCommunityScreenState();
}

class _RegionalCommunityScreenState extends State<RegionalCommunityScreen> {
  final CommunityService _communityService = CommunityService();
  final TextEditingController _messageController = TextEditingController();
  String _selectedRegion = 'Northern';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Region Selector
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _communityService.regions.map((region) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(region),
                  selected: _selectedRegion == region,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedRegion = region;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),

        // Messages Stream
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _communityService.getCommunityMessages(
                communityId: _selectedRegion, communityType: 'regional'),
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
                  return _buildMessageItem(message);
                },
              );
            },
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
                        communityId: _selectedRegion,
                        communityType: 'regional',
                        message: _messageController.text);
                    _messageController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageItem(DocumentSnapshot message) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isCurrentUser = message['sender_id'] == currentUserId;

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
                  message['text'],
                  style: GoogleFonts.ubuntu(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DistrictCommunityScreen extends StatefulWidget {
  const DistrictCommunityScreen({super.key});

  @override
  State<DistrictCommunityScreen> createState() =>
      _DistrictCommunityScreenState();
}

class _DistrictCommunityScreenState extends State<DistrictCommunityScreen> {
  final CommunityService _communityService = CommunityService();
  final TextEditingController _messageController = TextEditingController();
  String? _selectedDistrictId;
  List<Map<String, dynamic>> _districts = [];

  @override
  void initState() {
    super.initState();
    _fetchDistricts();
  }

  Future<void> _fetchDistricts() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('district_communities')
          .get();

      setState(() {
        _districts = querySnapshot.docs
            .map((doc) => {'id': doc.id, 'name': doc['name']})
            .toList();

        // Set first district as default if exists
        if (_districts.isNotEmpty) {
          _selectedDistrictId = _districts.first['id'];
        }
      });
    } catch (e) {
      print('Error fetching districts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // District Selector
        if (_districts.isNotEmpty)
          DropdownButton<String>(
            value: _selectedDistrictId,
            hint: const Text('Select District'),
            items: _districts.map<DropdownMenuItem<String>>((district) {
              return DropdownMenuItem<String>(
                value: district['id'] as String,
                child: Text(district['name'] as String),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDistrictId = newValue;
              });
            },
          ),

        // Messages Stream
        if (_selectedDistrictId != null)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _communityService.getCommunityMessages(
                  communityId: _selectedDistrictId!, communityType: 'district'),
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
                    return _buildMessageItem(message);
                  },
                );
              },
            ),
          ),

        // Message Input
        if (_selectedDistrictId != null)
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
                    if (_messageController.text.isNotEmpty &&
                        _selectedDistrictId != null) {
                      _communityService.sendMessageToCommunity(
                          communityId: _selectedDistrictId!,
                          communityType: 'district',
                          message: _messageController.text);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMessageItem(DocumentSnapshot message) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isCurrentUser = message['sender_id'] == currentUserId;

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
                  message['text'],
                  style: GoogleFonts.ubuntu(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  /// List of Tab Bar Item
  List<String> items = [
    "Regional Communities",
    "District Communities",
  ];

  /// List of icons for Bottom Navigation Bar
  List<IconData> icons = [
    Icons.public,
    Icons.apartment,
  ];

  /// List of pages for each tab
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const RegionalCommunityScreen(),
      const DistrictCommunityScreen(),
    ];
  }

  int current = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          items[current],
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios,
                color: AppColors.backgroundColor)),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement search functionality
            },
            icon: const Icon(Icons.search, color: Colors.white),
          )
        ],
      ),
      body: PageView.builder(
        itemCount: pages.length,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return pages[index];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(items.length, (index) {
          return BottomNavigationBarItem(
            icon: Icon(icons[index]),
            label: items[index],
          );
        }),
        currentIndex: current,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        onTap: (index) {
          setState(() {
            current = index;
          });
          pageController.animateToPage(
            current,
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}
