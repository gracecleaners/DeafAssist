import 'dart:io';
import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/modals/interpreter_info.dart';
import 'package:deafassist/services/interpreter_service.dart';
import 'package:deafassist/views/screens/auth/loginpage.dart';
import 'package:deafassist/views/screens/deaf/view_interpreters.dart';
import 'package:deafassist/views/screens/trial.dart';
import 'package:deafassist/views/widgets/text_field.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddInterpreterPage extends StatefulWidget {
  @override
  _AddInterpreterPageState createState() => _AddInterpreterPageState();
}

class _AddInterpreterPageState extends State<AddInterpreterPage> {
  final InterpreterService interpreterService = InterpreterService();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController yearsOfExperienceController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController currentEmployerController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  bool _isAvailable = true;

  String _profileImageUrl = "";
  File? _image; // Variable to store the selected image file

  Future<void> _uploadImageToFirebase() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    setState(() {
      _image = File(file.path);
    });

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('profile_images');

    // Creating the reference for image to be stored
    Reference referenceImagetoUpload = referenceDirImages.child(fileName);

    try {
      // Store the file
      await referenceImagetoUpload.putFile(_image!);

      // Success: create download URL
      _profileImageUrl = await referenceImagetoUpload.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      // Optionally show an error message to the user
    }
  }

  Future<void> _submitForm() async {
    if (_profileImageUrl.isEmpty) {
      // Handle the case where the image URL is not available
      print('Profile image is not uploaded');
      return;
    }

    final interpreter = Interpreter(
      fullName: fullNameController.text,
      email: emailController.text,
      telephone: telephoneController.text,
      yearsOfExperience: int.tryParse(yearsOfExperienceController.text) ?? 0,
      district: districtController.text,
      linkedin: linkedinController.text,
      twitter: twitterController.text,
      currentEmployer: currentEmployerController.text,
      aboutMe: aboutMeController.text,
      profileImageUrl: _profileImageUrl,
      isAvailable: _isAvailable,
    );

    try {
      await interpreterService.addInterpreter(interpreter);

      // Ensure Navigator is not in an invalid state
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.pop(context); // Close the current page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Trial(),
          ),
        );
      });
    } catch (e) {
      print('Error adding interpreter: $e');
      // Optionally show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Enter your information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _uploadImageToFirebase,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[700])
                      : null,
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(hintText: "Full Names", controller: fullNameController),
              SizedBox(height: 20),
              CustomTextField(hintText: "Email Address", controller: emailController),
              SizedBox(height: 20),
              CustomTextField(hintText: "Telephone Number", controller: telephoneController),
              SizedBox(height: 20),
              CustomTextField(hintText: "Years of Experience", controller: yearsOfExperienceController),
              SizedBox(height: 20),
              CustomTextField(hintText: "District of Residence", controller: districtController),
              SizedBox(height: 20),
              CustomTextField(hintText: "LinkedIn Handle", controller: linkedinController),
              SizedBox(height: 20),
              CustomTextField(hintText: "Twitter Handle", controller: twitterController),
              SizedBox(height: 20),
              CustomTextField(hintText: "Current Employer", controller: currentEmployerController),
              SizedBox(height: 20),
              CustomTextField(hintText: "About Me", maxLines: 5, controller: aboutMeController),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _submitForm,
                  child: MyText(
                    text: "Submit",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
