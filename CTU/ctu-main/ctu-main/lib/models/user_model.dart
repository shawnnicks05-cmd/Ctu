import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String department;
  final String yearLevel;
  final String section;
  final String? userType;
  final DateTime createdAt;

  UserModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.department,
    required this.yearLevel,
    required this.section,
    this.userType,
    required this.createdAt,
  });

  // Convert user model to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'department': department,
      'yearLevel': yearLevel,
      'section': section,
      'userType': userType,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create user model from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    DateTime createdAt;
    
    if (map['createdAt'] != null) {
      if (map['createdAt'] is Timestamp) {
        createdAt = (map['createdAt'] as Timestamp).toDate();
      } else if (map['createdAt'] is DateTime) {
        createdAt = map['createdAt'] as DateTime;
      } else {
        createdAt = DateTime.now(); // Fallback
      }
    } else {
      createdAt = DateTime.now(); // Fallback
    }
    
    return UserModel(
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      department: map['department'] ?? '',
      yearLevel: map['yearLevel'] ?? '',
      section: map['section'] ?? '',
      userType: map['userType'],
      createdAt: createdAt,
    );
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? department,
    String? yearLevel,
    String? section,
    String? userType,
    DateTime? createdAt,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
      yearLevel: yearLevel ?? this.yearLevel,
      section: section ?? this.section,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
