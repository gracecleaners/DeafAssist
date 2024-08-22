import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/services/interpreter_service.dart';
import 'package:deafassist/views/widgets/search.dart';
import 'package:deafassist/views/widgets/view_interpreter_widget.dart';
import 'package:flutter/material.dart';
import 'package:deafassist/modals/interpreter_info.dart';

class ViewInterpreters extends StatefulWidget {
  ViewInterpreters({Key? key}) : super(key: key);

  @override
  State<ViewInterpreters> createState() => _ViewInterpretersState();
}

class _ViewInterpretersState extends State<ViewInterpreters> {
  Interpreter? interpreter;
  final InterpreterService _interpreterService = InterpreterService(); // Initialize InterpreterService

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
                    'Book Interpreter',
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
                labelText: "Search for interpreter by name",
                suffixIcon: Icon(Icons.send, color: AppColors.primaryColor),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: FutureBuilder<List<Interpreter>>(
                  future: _interpreterService.getInterpreters(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No interpreters found'));
                    } else {
                      final interpreters = snapshot.data!;
                      return ListView.builder(
                        itemCount: interpreters.length,
                        itemBuilder: (context, index) {
                          return ViewInterpreterWidget(interpreter: interpreters[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
