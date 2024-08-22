import 'package:deafassist/views/screens/deaf/bottomNavDeaf.dart';
import 'package:deafassist/views/screens/interpreter/fill_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../utils/navigation_utils.dart';
import '../views/screens/trial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController {
  final AuthService _authService = AuthService();

  Future<void> signIn(
    BuildContext context,
    String email,
    String password,
    GlobalKey<FormState> formKey,
  ) async {
    if (formKey.currentState!.validate()) {
      try {
        User? user = await _authService.signIn(email, password);
        route(context, user);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void route(BuildContext context, User? user) {
    FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('role') == "deaf") {
            NavigationUtils.navigateTo(context, BottomNavDeaf());
          } else {
            NavigationUtils.navigateTo(context, AddInterpreterPage());
          }
        } else {
          print('Document does not exist on the database');
        }
      },
    );
  }

  void sendPasswordReset(BuildContext context, String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("We have sent you a password reset link")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
