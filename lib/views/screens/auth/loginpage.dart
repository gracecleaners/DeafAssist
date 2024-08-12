import 'package:deafassist/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:deafassist/utils/form_validator.dart';
import 'package:deafassist/utils/snackbar_utils.dart';
import 'package:deafassist/views/screens/auth/registerpage.dart';
import 'package:deafassist/const/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController forgotPasswordEmailController = TextEditingController();

  final LoginController _loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60.0, left: 19),
            child: Text(
              'Hello \nSign in!',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180.0),
            child: Container(
              decoration: BoxDecoration(
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
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Welcome",
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        _buildEmailField(),
                        SizedBox(height: 20.0),
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
        prefixIcon: Icon(Icons.email),
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
        prefixIcon: Icon(Icons.lock),
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
        child: Text("Forgot Password?"),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          padding: EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          _loginController.signIn(
            context,
            emailController.text,
            passwordController.text,
            _formKey,
          );
        },
        child: Text(
          "LOGIN",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Don’t have an account yet?"),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },
          child: Text("Register"),
        ),
      ],
    );
  }
}
