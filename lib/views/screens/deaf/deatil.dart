import 'package:deafassist/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:deafassist/modals/course.dart';

class CourseDetail extends StatelessWidget {
  final String courseId;

  const CourseDetail({Key? key, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final course = Courses.getCourseById(courseId);

    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Not Found')),
        body: const Center(child: Text('Course details are unavailable')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
        title: Text(
          course.name ?? 'Course Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            Image(
              image: AssetImage(course.imageUrl ??
                  'assets/images/default_image.png'), // Fallback to a default image if `course.imageUrl` is null
              width: double.infinity,
              // height: 250,
              fit: BoxFit.cover,
            ),

            // Course Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          course.name ?? 'Unnamed Course',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${course.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Course Description
                  Text(
                    course.description ?? 'No description available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Course Details
                  _buildDetailRow(Icons.access_time, 'Duration',
                      '${course.duration} weeks'),
                  _buildDetailRow(Icons.calendar_today, 'Dates',
                      '${course.startDate} - ${course.endDate}'),
                  _buildDetailRow(Icons.schedule, 'Time',
                      '${course.startTime} - ${course.endTime}'),
                  _buildDetailRow(Icons.location_on, 'Mode',
                      course.mode ?? 'Not specified'),
                  _buildDetailRow(Icons.trending_up, 'Difficulty',
                      course.difficulty ?? 'Not specified'),

                  const SizedBox(height: 20),

                  // Instructor Details
                  Text(
                    'Instructor',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            NetworkImage(course.instructorImage ?? ''),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.instructor ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              course.instructorBio ?? 'No bio available',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Course Objectives
                  Text(
                    'Course Objectives',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (course.objectives ?? []).map((objective) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle,
                                color: Colors.green, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                objective,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  // Enroll Button
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement enrollment logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Enrollment coming soon!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text(
                        'Enroll Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 20),
          const SizedBox(width: 10),
          Text(
            '$label: $value',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
