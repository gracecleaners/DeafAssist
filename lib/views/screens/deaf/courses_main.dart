import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/services/interpreter_service.dart';
import 'package:deafassist/views/widgets/search.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:deafassist/views/widgets/view_interpreter_widget.dart';
import 'package:flutter/material.dart';
import 'package:deafassist/modals/interpreter_info.dart';

class Courses extends StatefulWidget {
  Courses({Key? key}) : super(key: key);

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  // Initialize InterpreterService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back, color: AppColors.backgroundColor,size: 30,)),
                  SizedBox(width: 20,),
                  Text(
                    'Courses',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quicksand',
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SearchTextField(
                labelText: "Search for course by name",
                suffixIcon: Icon(Icons.send, color: AppColors.primaryColor),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(text: "No Course has been uploaded!", fontSize: 22,)
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
