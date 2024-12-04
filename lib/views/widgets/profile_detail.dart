import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase import

class ProductItemsDetail extends StatelessWidget {
  final String interpreterId; // Interpreter ID to fetch the details from Firebase

  const ProductItemsDetail({super.key, required this.interpreterId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<DocumentSnapshot>(
      // Fetch interpreter details from Firestore using the interpreterId
      future: FirebaseFirestore.instance.collection('interpreters').doc(interpreterId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator while data is being fetched
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Handle any errors
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('Interpreter not found.'));
        }

        var interpreterData = snapshot.data!.data() as Map<String, dynamic>;

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
                      const SizedBox(height: 5),
                      Text(
                        interpreterData['fullName'], // Use the full name from Firestore
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black),
                      ),
                      Text(
                        interpreterData['email'], // Use the email from Firestore
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
                        interpreterData['telephone'], // Use the telephone from Firestore
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.deepOrange),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyText(
                          text: "About Me",
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      Text(
                        interpreterData['aboutMe'], // Use the aboutMe from Firestore
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            fontSize: 18,
                            color: Colors.black45),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Years of experience : ",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            "${interpreterData['yearsOfExperience']} yrs", // Use yearsOfExperience
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
                            child: const MyText(
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
                            interpreterData['district'], // Use the district as region
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
                                    title: const Text("Current Employer"),
                                    content: Text(interpreterData['currentEmployer']), // Display previous employer info
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const MyText(
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
                            child: const MyText(
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
                              child: const MyText(
                                text: "Deaf Training",
                                color: Colors.green,
                                fontSize: 18,
                              )),
                          TextButton(
                              onPressed: () {},
                              child: const MyText(
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
                          child: const MyText(
                            text: "Book",
                            color: AppColors.backgroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.chat,
                            color: Colors.green,
                            size: 35,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
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
      },
    );
  }
}
