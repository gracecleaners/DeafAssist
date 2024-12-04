import 'package:cloud_firestore/cloud_firestore.dart';

class InterpreterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'interpreters';

  // Fetch all interpreters with the role 'Interpreter'
  Future<List<Map<String, dynamic>>> getInterpreters() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'Interpreter')
          .get();

      // Return a list of interpreters as a list of maps
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Add the document ID for reference
          ...doc.data(), // Include all fields in the document
        };
      }).toList();
    } catch (e) {
      print('Error fetching interpreters: $e');
      throw Exception("Failed to fetch interpreters: $e");
    }
  }

  // Fetch a specific interpreter by ID
  Future<Map<String, dynamic>?> getInterpreterById(String id) async {
    try {
      final doc = await _firestore.collection(collection).doc(id).get();
      if (doc.exists) {
        return {
          'id': doc.id, // Add the document ID for reference
          ...doc.data()!, // Include all fields in the document
        };
      } else {
        print('Interpreter not found');
        return null;
      }
    } catch (e) {
      print('Error fetching interpreter: $e');
      rethrow; // Rethrow exception to handle it where this method is called
    }
  }

  // Update an existing interpreter by ID
  Future<void> updateInterpreter(String id, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection(collection).doc(id).update(updatedData);
      print('Interpreter updated successfully.');
    } catch (e) {
      print('Error updating interpreter: $e');
      rethrow; // Rethrow exception to handle it where this method is called
    }
  }

  // Delete an interpreter by ID
  Future<void> deleteInterpreter(String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
      print('Interpreter deleted successfully.');
    } catch (e) {
      print('Error deleting interpreter: $e');
      rethrow; // Rethrow exception to handle it where this method is called
    }
  }
}
