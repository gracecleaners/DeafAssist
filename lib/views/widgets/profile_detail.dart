import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:deafassist/modals/interpreter_info.dart'; // Import the Interpreter model

class ProductItemsDetail extends StatelessWidget {
  final Interpreter interpreter; // Accept an Interpreter object

  const ProductItemsDetail({super.key, required this.interpreter});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height * 0.4,
      child: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    interpreter.fullName, // Use the full name from the interpreter
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black),
                  ),
                  Text(
                    interpreter.email, // Use the email from the interpreter
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black38),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    interpreter.telephone, // Use the telephone from the interpreter
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.deepOrange),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  // StarRating(rating: product.rating),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                      text: "About Me",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  Text(
                    interpreter.aboutMe, // Use the aboutMe from the interpreter
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        fontSize: 18,
                        color: Colors.black45),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Years of experience : ",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        "${interpreter.yearsOfExperience} yrs", // Use yearsOfExperience
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black38),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Degrees and Training : ",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: MyText(
                          text: "View",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Region : ",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        interpreter.district, // Use the district as region
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black38),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Previous Employment : ",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          // Show dialog with previous employer details
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Current Employer"),
                                content: Text(interpreter.currentEmployer), // Display previous employer info
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: MyText(
                                      text: "Close",
                                      fontSize: 18,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: MyText(
                          text: "View",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                  const Text(
                    "Certifications",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: MyText(
                            text: "Deaf Training",
                            color: Colors.green,
                            fontSize: 18,
                          )),
                      TextButton(
                          onPressed: () {},
                          child: MyText(
                            text: "Deaf Training",
                            color: Colors.green,
                            fontSize: 18,
                          )),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {},
                      child: MyText(
                        text: "Book",
                        color: AppColors.backgroundColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.chat,
                        color: Colors.green,
                        size: 35,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.video_call,
                        color: Colors.green,
                        size: 40,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
