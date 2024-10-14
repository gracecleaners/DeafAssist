import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseDetailPage extends StatefulWidget {
  final int courseId;

  CourseDetailPage({required this.courseId});

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  Map courseDetail = {};

  @override
  void initState() {
    super.initState();
    fetchCourseDetail();
  }

  Future<void> fetchCourseDetail() async {
    final response = await http.get(
        Uri.parse('https://okumuoscar.pythonanywhere.com/api/courses/${widget.courseId}/'));

    if (response.statusCode == 200) {
      setState(() {
        courseDetail = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load course detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseDetail['course_name'] ?? 'Course Detail'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: courseDetail.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description: ${courseDetail['description']}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Instructor: ${courseDetail['instructor']}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Start Date: ${courseDetail['start_date']}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('End Date: ${courseDetail['end_date']}',
                      style: TextStyle(fontSize: 16)),
                  // Add more course details here
                ],
              ),
            ),
    );
  }
}
