import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:deafassist/modals/availability.dart';

class ScheduleAvailabilityScreen extends StatefulWidget {
  const ScheduleAvailabilityScreen({Key? key}) : super(key: key);

  @override
  _ScheduleAvailabilityScreenState createState() => _ScheduleAvailabilityScreenState();
}

class _ScheduleAvailabilityScreenState extends State<ScheduleAvailabilityScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  final Set<DateTime> _selectedDays = {};

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      // Normalize the selected day to remove time components
      final normalizedDay = DateTime(
        selectedDay.year, 
        selectedDay.month, 
        selectedDay.day
      );

      if (_selectedDays.contains(normalizedDay)) {
        _selectedDays.remove(normalizedDay);
      } else {
        _selectedDays.add(normalizedDay);
      }
      _focusedDay = focusedDay;
    });
  }

  void _clearSelectedDates() {
    setState(() {
      _selectedDays.clear();
    });
  }

  void _showSelectedDates() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selected Dates'),
          content: SingleChildScrollView(
            child: Column(
              children: _selectedDays
                  .map((date) => Text(
                      '${date.year}-${date.month}-${date.day}'))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveAvailability() async {
    try {
      // Get current user's ID
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in first')),
        );
        return;
      }

      // Reference to Firestore collection
      final availabilityCollection = FirebaseFirestore.instance
          .collection('interpreter_availability');

      // Check for existing availability document
      final querySnapshot = await availabilityCollection
          .where('interpreterId', isEqualTo: currentUser.uid)
          .get();

      // Create availability object
      final availability = InterpreterAvailability(
        interpreterId: currentUser.uid,
        availableDates: _selectedDays.toList(),
      );

      if (querySnapshot.docs.isNotEmpty) {
        // Update existing document
        await querySnapshot.docs.first.reference.update({
          'availableDates': FieldValue.arrayUnion(
            _selectedDays.map((date) => date.toIso8601String()).toList()
          )
        });
      } else {
        // Add new document
        await availabilityCollection.add(availability.toMap());
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Availability saved successfully!')),
      );

      // Clear selection after saving
      setState(() {
        _selectedDays.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving availability: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Your Availability'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Normalize the day for comparison
              return _selectedDays.contains(
                DateTime(day.year, day.month, day.day)
              );
            },
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.green.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selected Days: ${_selectedDays.length}',
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.list),
                onPressed: _showSelectedDates,
                tooltip: 'View Selected Dates',
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSelectedDates,
                tooltip: 'Clear Selected Dates',
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectedDays.isNotEmpty ? _saveAvailability : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(200, 50),
            ),
            child: const Text(
              'Save Availability',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}