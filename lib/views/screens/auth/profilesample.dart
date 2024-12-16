import 'dart:io';
import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/services/auth_service.dart';
import 'package:deafassist/views/screens/auth/loginpage.dart';
import 'package:deafassist/views/screens/deaf/settingsDeaf.dart';
import 'package:deafassist/views/screens/deaf/support.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ProfileScreen is a stateful widget for user profile management
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Service and Firebase instances
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // User profile data
  String _userName = 'Loading...';
  String _userEmail = 'Loading...';
  String _profileImageUrl = '';
  String _userRole = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc.data()?['name'] ?? 'No Name';
          _userEmail = userDoc.data()?['email'] ?? 'No Email';
          _profileImageUrl = userDoc.data()?['profileImage'] ?? '';
          _userRole = userDoc.data()?['role'] ?? 'User';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  // Pick and upload profile image from gallery
  Future<void> _pickAndUploadProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image == null) return;

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Upload image to Firebase Storage
      final storageRef = _storage.ref().child('profile_images/${currentUser.uid}.jpg');
      await storageRef.putFile(File(image.path));

      // Get download URL
      final imageUrl = await storageRef.getDownloadURL();

      // Update Firestore with new image URL
      await _firestore.collection('users').doc(currentUser.uid).update({
        'profileImage': imageUrl,
      });

      // Update local state
      setState(() {
        _profileImageUrl = imageUrl;
      });

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully')),
      );
    } catch (e) {
      // Close loading dialog if still open
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile image: $e')),
      );
    }
  }

  // Show dialog to edit user profile
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateUserProfile(
                  nameController.text.trim(), 
                  emailController.text.trim()
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  // Update user profile in Firestore and Firebase Authentication
  Future<void> _updateUserProfile(String newName, String newEmail) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Validate input
      if (newName.isEmpty || newEmail.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name and email cannot be empty')),
        );
        return;
      }

      // Update Firestore document
      await _firestore.collection('users').doc(currentUser.uid).update({
        'name': newName,
        'email': newEmail,
      });

      // Update email in Firebase Authentication if changed
      if (newEmail != _userEmail) {
        await currentUser.updateEmail(newEmail);
      }

      // Refresh user data
      setState(() {
        _userName = newName;
        _userEmail = newEmail;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  // Handle sign out process
  void _handleSignOut(BuildContext context) async {
    try {
      await _authService.signOut();
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => LoginPage())
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 26,),
              const Text(
                "My Account", 
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 26,),
              
              // Profile Image with Edit Option
              Stack(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _profileImageUrl.isNotEmpty
                          ? Image.network(
                              _profileImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset("assets/images/user.png");
                              },
                            )
                          : Image.asset("assets/images/user.png"),
                    ),
                  ),
                  // Edit Profile Image Button
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit, 
                          color: Colors.white,
                        ),
                        onPressed: _pickAndUploadProfileImage,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              
              // Name and Email
              Text(
                _userName.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(height: 5),
              Text(_userEmail),
             
              const SizedBox(height: 10),

              // Edit Profile Button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _showEditProfileDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 10),

              // List Tiles
              const ListTileWidget(
                title: "My transactions", 
                icon: Icons.wallet_travel
              ),
              const ListTileWidget(
                title: "My Bookings", 
                icon: Icons.calendar_month
              ),
              ListTileWidget(
                title: "Settings", 
                icon: Icons.settings,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AppSettingsPage(),
                    ),
                  );
                },
              ),
             ListTileWidget(
                title: "Support & Inquiries", 
                icon: Icons.help_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> SupportScreen())),
              ),
              ListTileWidget(
                title: "Sign Out",
                icon: Icons.logout,
                onTap: () => _handleSignOut(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable ListTile Widget
class ListTileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const ListTileWidget({
    super.key, 
    required this.title, 
    required this.icon, 
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.primaryColor.withOpacity(0.3),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryColor,
        ),
      ),
      title: Text(title),
      trailing: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.2),
        ),
        child: const Icon(
          Icons.arrow_forward,
          color: Colors.grey,
        ),
      ),
    );
  }
}