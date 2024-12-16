import 'package:deafassist/controllers/login_controller.dart';
import 'package:deafassist/services/auth_service.dart';
import 'package:deafassist/views/screens/deaf/bottomNavDeaf.dart';
import 'package:deafassist/views/screens/interpreter/bttom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:deafassist/utils/form_validator.dart';
import 'package:deafassist/utils/snackbar_utils.dart';
import 'package:deafassist/views/screens/auth/registerpage.dart';
import 'package:deafassist/const/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController forgotPasswordEmailController =
      TextEditingController();

  final LoginController _loginController = LoginController();

  void _signIn(String email, String password) async {
    try {
      AuthService authService = AuthService();
      String? role = await authService.signInAndFetchRole(email, password);

      if (role != null) {
        if (role == 'deaf') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavDeaf()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavInterpreter()),
          );
        }
      } else {
        // Handle missing role scenario
        print("Role not found for user.");
      }
    } catch (e) {
      print("Error: $e");
      // Show error to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 19),
            child: Text(
              'Hello \nSign in!',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: ht * 0.03),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Welcome",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.normal, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        _buildEmailField(),
                        const SizedBox(height: 20.0),
                        _buildPasswordField(),
                        _buildForgotPasswordButton(context),
                        _buildLoginButton(context),
                        _buildRegisterButton(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        hintText: 'Email',
        filled: true,
        fillColor: AppColors.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: FormValidator.validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _isObscure,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
        prefixIcon: const Icon(Icons.lock),
        hintText: 'Password',
        filled: true,
        fillColor: AppColors.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: FormValidator.validatePassword,
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {
          _loginController.sendPasswordReset(
            context,
            forgotPasswordEmailController.text,
          );
        },
        child: const Text("Forgot Password?", style: TextStyle(color: Colors.grey),),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          // _loginController.signIn(
          //   context,
          //   emailController.text,
          //   passwordController.text,
          //   _formKey,
          // );
          _signIn(emailController.text, passwordController.text);
        },
        child: const Text(
          "LOGIN",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Don’t have an account yet?", style: TextStyle(color: Colors.white),),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
          child: const Text("Register", style: TextStyle(color: Colors.grey),),
        ),
      ],
    );
  }
}
