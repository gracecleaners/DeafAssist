import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/views/screens/deaf/view_interpreter_details.dart';
import 'package:deafassist/views/widgets/search.dart';
import 'package:flutter/material.dart';

class ViewInterpreters extends StatefulWidget {
  const ViewInterpreters({super.key});

  @override
  State<ViewInterpreters> createState() => _ViewInterpretersState();
}

class _ViewInterpretersState extends State<ViewInterpreters> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> allInterpreters = [];
  List<QueryDocumentSnapshot> displayedInterpreters = [];

  @override
  void initState() {
    super.initState();
    _loadInterpreters();
  }

  Future<void> _loadInterpreters() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'interpreter')
          .get();

      setState(() {
        allInterpreters = querySnapshot.docs;
        displayedInterpreters = querySnapshot.docs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading interpreters: $e")),
      );
    }
  }

  void _filterInterpreters(String query) {
    final filteredList = allInterpreters.where((interpreterDoc) {
      final interpreterData = interpreterDoc.data() as Map<String, dynamic>;
      
      // Search by name or email (case-insensitive)
      final name = (interpreterData['name'] ?? '').toLowerCase();
      final email = (interpreterData['email'] ?? '').toLowerCase();
      final searchQuery = query.toLowerCase();

      return name.contains(searchQuery) || email.contains(searchQuery);
    }).toList();

    setState(() => displayedInterpreters = filteredList);
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
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.backgroundColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
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
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SearchTextField(
                labelText: "Search interpreter by name or email",
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
                onChanged: _filterInterpreters,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: displayedInterpreters.isEmpty
                    ? const Center(child: Text('No interpreters found'))
                    : ListView.separated(
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(left: 80),
                          child: Divider(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        itemCount: displayedInterpreters.length,
                        itemBuilder: (context, index) {
                          final interpreterData = displayedInterpreters[index].data() 
                              as Map<String, dynamic>;
                          final interpreterId = displayedInterpreters[index].id;
                          
                          return InkWell(
                            onTap: () {
                              // Navigate to interpreter details
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileDetailScreen(
                                    interpreterId: interpreterId,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  // Profile Picture
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: interpreterData['profileImageUrl'] != null
                                          ? DecorationImage(
                                              image: NetworkImage(interpreterData['profileImageUrl']),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                      color: interpreterData['profileImageUrl'] == null 
                                          ? Colors.grey.shade300 
                                          : null,
                                    ),
                                    child: interpreterData['profileImageUrl'] == null
                                        ? Icon(
                                            Icons.person, 
                                            color: Colors.grey.shade600,
                                            size: 30,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  // Name and Email
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          interpreterData['name'] ?? 'No Name',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          interpreterData['email'] ?? 'No Email',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Trailing icon
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
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