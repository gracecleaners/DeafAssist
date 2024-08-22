import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/modals/interpreter_info.dart';
import 'package:deafassist/views/screens/deaf/view_interpreter_details.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ViewInterpreterWidget extends StatelessWidget {
  final Interpreter interpreter; // Add Interpreter parameter

  const ViewInterpreterWidget({super.key, required this.interpreter});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  interpreter: interpreter, // Pass the interpreter to DetailScreen
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: interpreter.profileImageUrl.isNotEmpty
                      ? NetworkImage(interpreter.profileImageUrl) // Load image from URL
                      : null,
                  child: interpreter.profileImageUrl.isEmpty
                      ? Icon(Icons.person, size: 35) // Display default icon if no image
                      : null,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                        text: interpreter.fullName,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    MyText(
                      text: interpreter.email,
                      color: Colors.black.withOpacity(0.6),
                    )
                  ],
                ),
                Spacer(),
                // Container(
                //     decoration: BoxDecoration(
                //         color: Colors.green.withOpacity(0.9),
                //         borderRadius: BorderRadius.circular(20)),
                //     child: Padding(
                //       padding: const EdgeInsets.all(6.0),
                //       child: MyText(
                //         text: interpreter.isAvailable
                //             ? "Available"
                //             : "Unavailable",
                //         color: AppColors.backgroundColor,
                //       ),
                //     ))
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Divider(),
        )
      ],
    );
  }
}
