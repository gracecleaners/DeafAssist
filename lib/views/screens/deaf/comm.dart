import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/services/community.dart';
import 'package:deafassist/views/screens/deaf/com_chat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegionalCommunityScreen extends StatefulWidget {
  const RegionalCommunityScreen({super.key});

  @override
  State<RegionalCommunityScreen> createState() => _RegionalCommunityScreenState();
}

class _RegionalCommunityScreenState extends State<RegionalCommunityScreen> {
  final CommunityService _communityService = CommunityService();
  String _selectedRegion = 'Northern';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Regional Communities',
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
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.backgroundColor),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _communityService.regions.length,
        itemBuilder: (context, index) {
          final region = _communityService.regions[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedRegion = region;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(region: _selectedRegion),
                ),
              );
            },
            child: Stack(
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      region,
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: StreamBuilder<int>(
                    stream: _communityService.getUnreadMessageCount(
                      communityId: region,
                      communityType: 'regional',
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == 0) {
                        return SizedBox.shrink();
                      }
                      return CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.red,
                        child: Text(
                          snapshot.data.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}