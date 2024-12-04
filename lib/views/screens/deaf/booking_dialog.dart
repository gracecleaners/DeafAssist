import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InterpreterBookingDialog extends StatefulWidget {
  final String interpreterId;

  const InterpreterBookingDialog({Key? key, required this.interpreterId}) : super(key: key);

  @override
  _InterpreterBookingDialogState createState() => _InterpreterBookingDialogState();
}

class _InterpreterBookingDialogState extends State<InterpreterBookingDialog> {
  // List to store available dates for the interpreter
  List<DateTime> _availableDates = [];
  
  // Loading state to show progress indicator
  bool _isLoading = true;
  
  // Current user data to be used in booking
  Map<String, dynamic>? _currentUserData;
  
  // Selected date for booking
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Fetch interpreter availability and current user data when dialog initializes
    _fetchInterpreterAvailability();
    _fetchCurrentUserData();
  }

  // Fetch current user's data from Firestore
  Future<void> _fetchCurrentUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        
        setState(() {
          _currentUserData = userDoc.data();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    }
  }

  // Fetch available dates for the specific interpreter
  Future<void> _fetchInterpreterAvailability() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('interpreter_availability')
          .where('interpreterId', isEqualTo: widget.interpreterId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        
        final availableDatesRaw = data['availableDates'] as List<dynamic>? ?? [];
        setState(() {
          _availableDates = availableDatesRaw.map((timestamp) {
            return (timestamp is Timestamp) 
              ? timestamp.toDate() 
              : DateTime.parse(timestamp.toString());
          }).toList();
          
          // Sort dates in ascending order
          _availableDates.sort((a, b) => a.compareTo(b));
          
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading availability: $e')),
      );
    }
  }

  // Book interpreter for selected date
  Future<void> _bookInterpreter() async {
    if (_selectedDate == null || _currentUserData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and ensure user data is loaded')),
      );
      return;
    }

    try {
      // Send a booking request to the interpreter
      await FirebaseFirestore.instance.collection('interpreter_bookings').add({
        'interpreterId': widget.interpreterId,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'userName': _currentUserData?['name'] ?? 'Unknown User',
        'userEmail': _currentUserData?['email'] ?? 'No email',
        'bookingDate': _selectedDate,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Remove the booked date from interpreter's available dates
      await _updateInterpreterAvailability();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking request sent for ${DateFormat('MMMM d, yyyy').format(_selectedDate!)}'),
          backgroundColor: Colors.green,
        ),
      );

      // Close the dialog
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error booking interpreter: $e')),
      );
    }
  }

  // Update interpreter's availability after booking
  Future<void> _updateInterpreterAvailability() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('interpreter_availability')
          .where('interpreterId', isEqualTo: widget.interpreterId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        
        // Remove the selected date from available dates
        await FirebaseFirestore.instance
            .collection('interpreter_availability')
            .doc(docId)
            .update({
          'availableDates': FieldValue.arrayRemove([_selectedDate?.toIso8601String()])
        });
      }
    } catch (e) {
      print('Error updating interpreter availability: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Book an Interpreter'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select an Available Date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // List of available dates
                    if (_availableDates.isEmpty)
                      const Text(
                        'No availability found',
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      ...List.generate(
                        _availableDates.length,
                        (index) {
                          final date = _availableDates[index];
                          return CheckboxListTile(
                            title: Text(
                              DateFormat('EEEE, MMMM d, yyyy').format(date),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            value: _selectedDate == date,
                            onChanged: (bool? selected) {
                              setState(() {
                                // Deselect if already selected, otherwise select the date
                                _selectedDate = selected == true ? date : null;
                              });
                            },
                            activeColor: Colors.green,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: _selectedDate != null && _currentUserData != null
            ? _bookInterpreter 
            : null,
          child: const Text('Book'),
        ),
      ],
    );
  }
}