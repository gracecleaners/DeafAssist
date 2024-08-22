import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/services/auth_service.dart';
import 'package:deafassist/views/screens/auth/loginpage.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class Trial extends StatelessWidget {
  final AuthService _authService = AuthService();
 Trial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
             ),
      body: Center(
        child: Column(
          children: [
            MyText(text: "No Interpreter Data for Now, The app is still Under development. You will get interpreter data that you entered in deaf page", maxLines: 4,),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primaryColor
              ),
              onPressed: () async{
                 await _authService.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            }, icon: Icon(Icons.logout, color: Colors.white,))
          ],
        ),
      ),
    );
  }
}