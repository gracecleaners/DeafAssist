// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class CourseDetailPage extends StatefulWidget {
//   final String courseId;

//   const CourseDetailPage({super.key, required this.courseId});

//   @override
//   _CourseDetailPageState createState() => _CourseDetailPageState();
// }

// class _CourseDetailPageState extends State<CourseDetailPage> {
//   late DocumentSnapshot _course;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCourseDetails();
//   }

//   void _fetchCourseDetails() async {
//     try {
//       DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
//           .collection('courses')
//           .doc(widget.courseId)
//           .get();

//       setState(() {
//         _course = courseSnapshot;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching course details: $e');
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load course details: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : CustomScrollView(
//               slivers: [
//                 SliverAppBar(
//                   expandedHeight: 250,
//                   pinned: true,
//                   flexibleSpace: FlexibleSpaceBar(
//                     title: Text(
//                       _course['name'] ?? 'Course Details',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                     background: Hero(
//                       tag: _course.id,
//                       child: CachedNetworkImage(
//                         imageUrl: _course['imageUrl'] ?? '',
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) => const Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                         errorWidget: (context, url, error) => Image.asset(
//                           'assets/placeholder_course.png',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SliverPadding(
//                   padding: const EdgeInsets.all(16),
//                   sliver: SliverList(
//                     delegate: SliverChildListDelegate([
//                       _buildCourseInfo(),
//                       const SizedBox(height: 16),
//                       _buildCourseInstructor(),
//                       const SizedBox(height: 16),
//                       _buildCourseObjectives(),
//                       const SizedBox(height: 16),
//                       _buildCourseDetails(),
//                       const SizedBox(height: 20),
//                       // Enroll Button
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // Implement enrollment logic
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text('Enrollment coming soon!')),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.deepPurple,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 50, vertical: 15),
//                             textStyle: const TextStyle(fontSize: 18),
//                           ),
//                           child: const Text('Enroll Now'),
//                         ),
//                       ),
//                     ]),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildCourseInfo() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           _course['name'] ?? 'Unnamed Course',
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           _course['description'] ?? 'No description available',
//           style: TextStyle(
//             color: Colors.grey[700],
//             fontSize: 16,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             _buildInfoChip(Icons.calendar_today, 'Start: ${_course['startDate'] ?? 'TBA'}'),
//             const SizedBox(width: 8),
//             _buildInfoChip(Icons.access_time, 'Mode: ${_course['mode'] ?? 'N/A'}'),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoChip(IconData icon, String text) {
//     return Chip(
//       avatar: Icon(icon, size: 16),
//       label: Text(text),
//       backgroundColor: Colors.grey[200],
//     );
//   }

//   Widget _buildCourseInstructor() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 40,
//             backgroundImage: _course['instructorImage'] != null
//                 ? CachedNetworkImageProvider(_course['instructorImage'])
//                 : const AssetImage('assets/placeholder_instructor.png'),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Instructor: ${_course['instructor'] ?? 'Unknown'}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   _course['instructorBio'] ?? 'No instructor bio available',
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCourseObjectives() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Course Objectives',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         ...((_course['objectives'] as List<dynamic>?) ?? [])
//             .map((objective) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         '\u2022',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           objective,
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ))
//             .toList(),
//       ],
//     );
//   }

//   Widget _buildCourseDetails() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Course Details',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         _buildDetailRow('Start Date:', _course['startDate']),
//         _buildDetailRow('End Date:', _course['endDate']),
//         _buildDetailRow('Start Time:', _course['startTime']),
//         _buildDetailRow('End Time:', _course['endTime']),
//         _buildDetailRow('Mode:', _course['mode']),
//         if (_course['mode'] == 'Physical')
//           _buildDetailRow('Location:', _course['location']),
//       ],
//     );
//   }

//   Widget _buildDetailRow(String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value ?? 'Not available',
//               style: const TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
