import 'package:deafassist/views/screens/deaf/view_interpreter_details.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ViewInterpreterWidget extends StatelessWidget {
  final Map<String, dynamic> interpreter;

  const ViewInterpreterWidget({super.key, required this.interpreter});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DetailScreen(
            //       interpreter: interpreter, // Pass entire interpreter data
            //     ),
            //   ),
            // );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: interpreter['profileImageUrl']?.isNotEmpty ?? false
                      ? NetworkImage(interpreter['profileImageUrl'])
                      : null,
                  child: interpreter['profileImageUrl']?.isEmpty ?? true
                      ? const Icon(Icons.person, size: 35)
                      : null,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                        text: interpreter['fullName'] ?? 'No name',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    MyText(
                      text: interpreter['email'] ?? 'No email',
                      color: Colors.black.withOpacity(0.6),
                    )
                  ],
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: interpreter['isAvailable'] ?? false
                        ? Colors.green.withOpacity(0.9)
                        : Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: MyText(
                      text: interpreter['isAvailable'] ?? false
                          ? "Available"
                          : "Unavailable",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(),
        ),
      ],
    );
  }
}
