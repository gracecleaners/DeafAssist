import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/views/screens/deaf/courseDetails.dart';
import 'package:deafassist/views/screens/deaf/deatil.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:deafassist/modals/course.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Courses> _courses = [];
  List<Courses> _filteredCourses = [];
  String _selectedMode = 'All';
  String _selectedDifficulty = 'All';

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  void _fetchCourses() {
    setState(() {
      _courses = Courses.sampleCourses;
      _filteredCourses = _courses;
    });
  }

  void _filterCourses() {
    setState(() {
      _filteredCourses = _courses.where((course) {
        final nameMatch = _searchController.text.isEmpty ||
            (course.name
                    ?.toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ??
                false);

        final modeMatch =
            _selectedMode == 'All' || course.mode == _selectedMode;

        final difficultyMatch = _selectedDifficulty == 'All' ||
            course.difficulty == _selectedDifficulty;

        return nameMatch && modeMatch && difficultyMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
        title: const Text(
          'Courses',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterCourses(),
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Filter Rows
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Mode Filter
                _buildFilterChip('Mode', ['All', 'Online', 'Physical'],
                    (value) {
                  setState(() {
                    _selectedMode = value;
                    _filterCourses();
                  });
                }),
              ],
            ),
          ),

          // Course List
          Expanded(
            child: _filteredCourses.isEmpty
                ? const Center(child: Text('No courses found'))
                : ListView.builder(
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      return _buildCourseCard(course);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      String label, List<String> options, Function(String) onSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: DropdownButton<String>(
        hint: Text(label),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) => onSelected(newValue!),
      ),
    );
  }

  Widget _buildCourseCard(Courses course) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Image(
            image: AssetImage(course.imageUrl ?? 'assets/images/default_image.png'), // Fallback to a default image if `course.imageUrl` is null
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        title: Text(
          course.name ?? 'Unnamed Course',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.description ?? 'No description', overflow: TextOverflow.ellipsis,),
            const SizedBox(height: 5),
           
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 5),
                Text(course.instructor ?? 'Unknown Instructor'),
              ],
            ),
          ],
        ),
        trailing: Text(
          '\$${course.price?.toStringAsFixed(2) ?? '0.00'}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetail(courseId: course.id!),
            ),
          );
        },
      ),
    );
  }
}
