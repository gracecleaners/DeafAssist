import 'package:deafassist/views/screens/auth/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../utils/navigation_utils.dart';

class RegisterController {
  final AuthService _authService = AuthService();

  Future<void> signUp(
    BuildContext context,
    String username,
    String email,
    String password,
    String confirmPassword,
    String role,
    GlobalKey<FormState> formKey,
  ) async {
    if (formKey.currentState!.validate()) {
      try {
        User? user = await _authService.signUp(email, password);
        if (user != null) {
          await _authService.postDetailsToFirestore(
            user.uid, username, email, role,
          );
          NavigationUtils.navigateToAndReplace(context, const LoginPage());
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
