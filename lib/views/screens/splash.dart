import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:deafassist/views/screens/auth/loginpage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/logo.png',
      splashIconSize: 2000.0,
      centered: true,
      duration: 3100,
      splashTransition: SplashTransition.scaleTransition,
      nextScreen: LoginPage());
  }
}