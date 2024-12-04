import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/views/screens/deaf/booking_dialog.dart';
import 'package:deafassist/views/screens/deaf/chat_screen.dart';
import 'package:deafassist/views/screens/deaf/edit.dart';
import 'package:flutter/material.dart';

class ProfileDetailScreen extends StatefulWidget {
  final String interpreterId;

  const ProfileDetailScreen({Key? key, required this.interpreterId})
      : super(key: key);

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  Map<String, dynamic>? interpreterData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInterpreterDetails();
  }

  Future<void> _fetchInterpreterDetails() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.interpreterId)
          .get();

      setState(() {
        interpreterData = docSnapshot.data();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading interpreter details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFE2E8F0),
        appBar: AppBar(
          title: Text('Interpreter Profile'),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (interpreterData == null) {
      return Scaffold(
        backgroundColor: Color(0xFFE2E8F0),
        appBar: AppBar(
          title: Text('Interpreter Profile'),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: Center(child: Text('No interpreter data found')),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFE2E8F0),
      appBar: AppBar(
        title: Align(
            alignment: Alignment.center,
            child: Text(
              'Interpreter Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            // Profile Header Card
            _buildProfileHeaderCard(),
            SizedBox(height: 16),

            // Social Links Card
            _buildSocialLinksCard(),
            SizedBox(height: 16),

            // Personal Information Card
            _buildPersonalInfoCard(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 75,
              backgroundImage: interpreterData?['profileImageUrl'] != null
                  ? NetworkImage(interpreterData!['profileImageUrl'])
                  : null,
              child: interpreterData?['profileImageUrl'] == null
                  ? Icon(Icons.person, size: 75)
                  : null,
            ),
            SizedBox(height: 16),
            Text(
              (interpreterData?['name'] ?? 'No Name').toUpperCase(),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              interpreterData?['email'] ?? 'Interpreter',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return InterpreterBookingDialog(
                          interpreterId: widget.interpreterId,
                        );
                      },
                    );
                  },
                  child: Text(
                    'Book',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                ),
                SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {
                    if (interpreterData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            otherUserId: widget.interpreterId,
                            otherUserName:
                                interpreterData!['name'] ?? 'Unknown',
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Message',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    side: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinksCard() {
    return Card(
      elevation: 1,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildSocialLinkTile(
            icon: Icons.web,
            title: 'Website',
            subtitle: 'https://bootdey.com',
          ),
          Divider(height: 1),
          _buildSocialLinkTile(
            icon: Icons.code,
            title: 'Github',
            subtitle: 'bootdey',
          ),
          Divider(height: 1),
          _buildSocialLinkTile(
            icon: Icons.alternate_email,
            title: 'Twitter',
            subtitle: '@bootdey',
          ),
          Divider(height: 1),
          _buildSocialLinkTile(
            icon: Icons.photo,
            title: 'Instagram',
            subtitle: 'bootdey',
          ),
          Divider(height: 1),
          _buildSocialLinkTile(
            icon: Icons.facebook,
            title: 'Facebook',
            subtitle: 'bootdey',
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinkTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
                'Full Name', interpreterData?['name'] ?? 'Not specified'),
            _buildInfoRow(
                'Email', interpreterData?['email'] ?? 'Not specified'),
            _buildInfoRow(
                'Phone', interpreterData?['contact'] ?? 'Not specified'),
            _buildInfoRow(
                'District', interpreterData?['district'] ?? 'Not specified'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EditProfileDialog(
                      interpreterData: interpreterData!,
                      interpreterId: widget.interpreterId,
                    );
                  },
                ).then((result) {
                  // Refresh interpreter details if profile was updated
                  if (result == true) {
                    _fetchInterpreterDetails();
                  }
                });
              },
              child: Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
