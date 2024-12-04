import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/controllers/register_controller.dart';
import 'package:deafassist/services/auth_service.dart';
import 'package:deafassist/utils/form_validator.dart';
import 'package:deafassist/views/screens/auth/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showProgress = false;
  bool visible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isObscure = true;
  bool _isObscure1 = true;

  final AuthService authService = AuthService();

  Future<void> signUpAndPostDetails(
    BuildContext context,
    String email,
    String password,
    String name,
    String district,
    String employer,
    String contact,
    String experience,
    String role,
  ) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Add user details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'district': district,
        'currentEmployer': employer,
        'contact': contact,
        'yearsOfExperience': experience,
        'role': role,
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      throw Exception('Error during sign up: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
        ),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage("assets/images/logo.png"),
                          width: 100,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        Text("Create your account"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _buildEmailField(),
                  const SizedBox(height: 20.0),
                  _buildPasswordField(),
                  const SizedBox(height: 20.0),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 20.0),
                  _buildRegisterButton(),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        hintText: 'Email Address',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: FormValidator.validateEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: _isObscure,
      controller: passwordController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
        hintText: 'Password',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: FormValidator.validatePassword,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      obscureText: _isObscure1,
      controller: confirmPasswordController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_isObscure1 ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _isObscure1 = !_isObscure1;
            });
          },
        ),
        hintText: 'Confirm Password',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) =>
          FormValidator.validateConfirmPassword(passwordController.text, value),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF160303),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          setState(() {
            showProgress = true;
          });
          signUpAndPostDetails(
              context,
              emailController.text,
              passwordController.text,
              "name",
              "district",
              "employer",
              "contact",
              'experience',
              'deaf');
        },
        child: const Text(
          "REGISTER",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Already have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text("Login"),
        ),
      ],
    );
  }
}
