import 'package:deafassist/views/screens/auth/profilesample.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

    Future<void> login(String email, String password) async {
    final url = 'http://127.0.0.1:8000/account/api/login/';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      // Save token (optional) and navigate to homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePageTrial()), // Redirect to HomePage
      );
    } else {
      final error = json.decode(response.body)['error'];
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                login(email, password);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
