import 'package:deafassist/views/screens/auth/loginpage.dart';
import 'package:deafassist/views/screens/auth/loginsample.dart';
import 'package:deafassist/views/screens/auth/registerpage.dart';
import 'package:deafassist/views/screens/deaf/bottomNavDeaf.dart';
import 'package:deafassist/views/screens/deaf/homeDeaf.dart';
import 'package:deafassist/views/screens/deaf/view_interpreter_details.dart';
import 'package:deafassist/views/screens/deaf/view_interpreters.dart';
import 'package:deafassist/views/screens/interpreter/fill_info.dart';
import 'package:deafassist/views/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: SplashScreen(),
      // home: BottomNavDeaf(),
      // home: RegisterPage(),
      home: LoginScreen(),
    );
  }
}

