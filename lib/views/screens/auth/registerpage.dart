import 'package:deafassist/controllers/register_controller.dart';
import 'package:deafassist/views/screens/auth/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:deafassist/utils/form_validator.dart';
import 'package:deafassist/const/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showProgress = false;
  bool visible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isObscure1 = true;
  var options = ['interpreter', 'deaf'];
  var _currentItemSelected = 'deaf';
  var role = 'deaf';

  final RegisterController _registerController = RegisterController();

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
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const Image(
                          image: AssetImage("assets/images/logo.png"),
                          width: 100,
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          "Register",
                          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10.0),
                        const Text("Create your account"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _buildUsernameField(),
                  const SizedBox(height: 20.0),
                  _buildEmailField(),
                  const SizedBox(height: 20.0),
                  _buildPasswordField(),
                  const SizedBox(height: 20.0),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 20.0),
                  _buildRoleDropdown(),
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

  Widget _buildUsernameField() {
    return TextFormField(
      controller: usernameController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        hintText: 'Username',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: FormValidator.validateUsername,
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
      validator: (value) => FormValidator.validateConfirmPassword(passwordController.text, value),
    );
  }

  Widget _buildRoleDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Role: ",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        DropdownButton<String>(
          dropdownColor: const Color(0xFFC4C4C4),
          isDense: true,
          isExpanded: false,
          iconEnabledColor: Colors.black,
          focusColor: Colors.black,
          items: options.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(
                dropDownStringItem,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            );
          }).toList(),
          onChanged: (newValueSelected) {
            setState(() {
              _currentItemSelected = newValueSelected!;
              role = newValueSelected;
            });
          },
          value: _currentItemSelected,
        ),
      ],
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
          _registerController.signUp(
            context,
            usernameController.text,
            emailController.text,
            passwordController.text,
            confirmPasswordController.text,
            role,
            _formKey,
          );
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
