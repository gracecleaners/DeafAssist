import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String district = '';
  String contact = '';
  String employer = '';

  Future<void> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = 'http://yourbackend.com/profile/';
    
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      var profileData = json.decode(response.body);
      setState(() {
        name = profileData['name'];
        email = profileData['email'];
        district = profileData['district'];
        contact = profileData['contact'];
        employer = profileData['current_employer'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Name: $name'),
            Text('Email: $email'),
            Text('District: $district'),
            Text('Contact: $contact'),
            Text('Employer: $employer'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/edit-profile');
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
