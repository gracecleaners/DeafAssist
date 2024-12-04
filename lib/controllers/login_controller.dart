import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginController {
  final AuthService _authService = AuthService();


  void sendPasswordReset(BuildContext context, String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("We have sent you a password reset link")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
