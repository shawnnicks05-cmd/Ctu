import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collection = 'users';

  // Create user document in Firestore with full name as document ID
  Future<void> createUser(UserModel user) async {
    try {
      // Use full name as document ID (replace spaces with underscores for safety)
      String documentId = user.fullName.replaceAll(' ', '_').toLowerCase();
      
      await _db.collection(collection).doc(documentId).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Get user data by full name
  Future<UserModel?> getUserByFullName(String fullName) async {
    try {
      String documentId = fullName.replaceAll(' ', '_').toLowerCase();
      DocumentSnapshot doc = await _db.collection(collection).doc(documentId).get();
      
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Get user data by email
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(collection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user by email: $e');
    }
  }

  // Update user data
  Future<void> updateUser(UserModel user) async {
    try {
      String documentId = user.fullName.replaceAll(' ', '_').toLowerCase();
      await _db.collection(collection).doc(documentId).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user document
  Future<void> deleteUser(String fullName) async {
    try {
      String documentId = fullName.replaceAll(' ', '_').toLowerCase();
      await _db.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Get all users (for admin purposes)
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection(collection).get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }
}
