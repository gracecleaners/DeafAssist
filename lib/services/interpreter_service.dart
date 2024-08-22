import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafassist/modals/interpreter_info.dart';

class InterpreterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'interpreters';

  // Add a new interpreter to Firestore
  Future<void> addInterpreter(Interpreter interpreter) async {
    try {
      await _firestore.collection(collection).add(interpreter.toJson());
      print('Interpreter added successfully.');
    } catch (e) {
      print('Error adding interpreter: $e');
      throw e;  // Rethrow exception to handle it where this method is called
    }
  }

  // Fetch all interpreters from Firestore
  Future<List<Interpreter>> getInterpreters() async {
    try {
      final snapshot = await _firestore.collection(collection).get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Interpreter(
          fullName: data['fullName'] ?? '',
          email: data['email'] ?? '',
          telephone: data['telephone'] ?? '',
          yearsOfExperience: data['yearsOfExperience'] ?? 0,
          district: data['district'] ?? '',
          linkedin: data['linkedin'] ?? '',
          twitter: data['twitter'] ?? '',
          currentEmployer: data['currentEmployer'] ?? '',
          aboutMe: data['aboutMe'] ?? '',
          profileImageUrl: data['profileImageUrl'] ?? '',
          isAvailable: data['isAvailable'] ?? false, // Updated to include isAvailable
        );
      }).toList();
    } catch (e) {
      print('Error fetching interpreters: $e');
      throw e;  // Rethrow exception to handle it where this method is called
    }
  }

  // Fetch a specific interpreter by ID
  Future<Interpreter?> getInterpreterById(String id) async {
    try {
      final doc = await _firestore.collection(collection).doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        return Interpreter(
          fullName: data['fullName'] ?? '',
          email: data['email'] ?? '',
          telephone: data['telephone'] ?? '',
          yearsOfExperience: data['yearsOfExperience'] ?? 0,
          district: data['district'] ?? '',
          linkedin: data['linkedin'] ?? '',
          twitter: data['twitter'] ?? '',
          currentEmployer: data['currentEmployer'] ?? '',
          aboutMe: data['aboutMe'] ?? '',
          profileImageUrl: data['profileImageUrl'] ?? '',
          isAvailable: data['isAvailable'] ?? false, // Updated to include isAvailable
        );
      } else {
        print('Interpreter not found');
        return null;
      }
    } catch (e) {
      print('Error fetching interpreter: $e');
      throw e;  // Rethrow exception to handle it where this method is called
    }
  }

  // Update an existing interpreter
  Future<void> updateInterpreter(String id, Interpreter interpreter) async {
    try {
      await _firestore.collection(collection).doc(id).update(interpreter.toJson());
      print('Interpreter updated successfully.');
    } catch (e) {
      print('Error updating interpreter: $e');
      throw e;  // Rethrow exception to handle it where this method is called
    }
  }

  // Delete an interpreter by ID
  Future<void> deleteInterpreter(String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
      print('Interpreter deleted successfully.');
    } catch (e) {
      print('Error deleting interpreter: $e');
      throw e;  // Rethrow exception to handle it where this method is called
    }
  }



  // 
}
