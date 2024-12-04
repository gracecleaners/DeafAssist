import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/views/widgets/course_detail.dart';
import 'package:deafassist/views/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCourses = [];
  List<Map<String, dynamic>> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  void _filterCourses(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCourses = courses; // Show all courses if the search is empty
      } else {
        filteredCourses = courses.where((course) {
          return course['course_name']
              .toLowerCase()
              .contains(query.toLowerCase()); // Case-insensitive search
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchCourses() async {
    final response = await http
        .get(Uri.parse('https://okumuoscar.pythonanywhere.com/api/courses/'));

    if (response.statusCode == 200) {
      setState(() {
        // Decode the JSON directly into the list of maps
        courses = List<Map<String, dynamic>>.from(json.decode(response.body));
        filteredCourses = courses; // Update filteredCourses too
      });
    } else {
      throw Exception('Failed to load courses');
    }
  }

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
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.backgroundColor, size: 30),
                  ),
                  const SizedBox(width: 20),
                  const Text(
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
            const SizedBox(height: 5),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SearchTextField(
                labelText: "Search for course by name",
                suffixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
                controller: _searchController,
                onChanged: (value) {
                  _filterCourses(value); // Call the filter function when search input changes
                },
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 30),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: courses.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredCourses.length, // Change to filteredCourses
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        blurRadius: 20,
                                        offset: const Offset(4, 4),
                                        spreadRadius: 1.0),
                                    const BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 20,
                                        offset: Offset(4, 4),
                                        spreadRadius: 1.0),
                                  ],
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.1),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text(
                                  filteredCourses[index]['course_name'].toUpperCase(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(
                                  filteredCourses[index]['description'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  // Navigate to course detail page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CourseDetailPage(
                                        courseId: filteredCourses[index]['id'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
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
