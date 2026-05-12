import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class AutofillService {
  static final AutofillService _instance = AutofillService._internal();
  factory AutofillService() => _instance;
  AutofillService._internal();

  static const String _keySavedEmail = 'saved_email';
  static const String _keySavedPassword = 'saved_password';
  static const String _keySavedFullName = 'saved_full_name';
  static const String _keySavedStudentId = 'saved_student_id';
  static const String _keySavedCourse = 'saved_course';
  static const String _keySavedYear = 'saved_year';
  static const String _keySavedCampus = 'saved_campus';

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return; // Already initialized
    
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    } catch (e) {
      // Log error but don't throw - allow app to continue
      print('AutofillService initialization error: $e');
      _isInitialized = false;
    }
  }

  Future<void> saveUserInfo({
    String? email,
    String? password,
    String? fullName,
    String? studentId,
    String? course,
    String? year,
    String? campus,
  }) async {
    await _ensureInitialized();
    
    if (email != null && email.isNotEmpty) {
      await _prefs?.setString(_keySavedEmail, email);
    }
    
    if (password != null && password.isNotEmpty) {
      await _prefs?.setString(_keySavedPassword, password);
    }
    
    if (fullName != null && fullName.isNotEmpty) {
      await _prefs?.setString(_keySavedFullName, fullName);
    }
    
    if (studentId != null && studentId.isNotEmpty) {
      await _prefs?.setString(_keySavedStudentId, studentId);
    }
    
    if (course != null && course.isNotEmpty) {
      await _prefs?.setString(_keySavedCourse, course);
    }
    
    if (year != null && year.isNotEmpty) {
      await _prefs?.setString(_keySavedYear, year);
    }
    
    if (campus != null && campus.isNotEmpty) {
      await _prefs?.setString(_keySavedCampus, campus);
    }
  }

  Future<Map<String, String?>> getSavedUserInfo() async {
    await _ensureInitialized();
    
    return {
      'email': _prefs?.getString(_keySavedEmail),
      'password': _prefs?.getString(_keySavedPassword),
      'fullName': _prefs?.getString(_keySavedFullName),
      'studentId': _prefs?.getString(_keySavedStudentId),
      'course': _prefs?.getString(_keySavedCourse),
      'year': _prefs?.getString(_keySavedYear),
      'campus': _prefs?.getString(_keySavedCampus),
    };
  }

  Future<String?> getSavedEmail() async {
    await _ensureInitialized();
    return _prefs?.getString(_keySavedEmail);
  }

  Future<String?> getSavedPassword() async {
    await _ensureInitialized();
    return _prefs?.getString(_keySavedPassword);
  }

  Future<String?> getSavedFullName() async {
    await _ensureInitialized();
    return _prefs?.getString(_keySavedFullName);
  }

  Future<String?> getSavedStudentId() async {
    await _ensureInitialized();
    return _prefs?.getString(_keySavedStudentId);
  }

  Future<String?> getSavedCourse() async {
    await _ensureInitialized();
    return _prefs?.getString(_keySavedCourse);
  }

  Future<String?> getSavedYear() async {
    await _ensureInitialized();
    return _prefs?.getString(_keySavedYear);
  }

  Future<String?> getSavedCampus() async {
    await _ensureInitialized();
    return _prefs?.getString(_keySavedCampus);
  }

  Future<void> clearSavedInfo() async {
    await _ensureInitialized();
    await _prefs?.remove(_keySavedEmail);
    await _prefs?.remove(_keySavedPassword);
    await _prefs?.remove(_keySavedFullName);
    await _prefs?.remove(_keySavedStudentId);
    await _prefs?.remove(_keySavedCourse);
    await _prefs?.remove(_keySavedYear);
    await _prefs?.remove(_keySavedCampus);
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  // Get device-specific suggestions
  Map<String, String> getDeviceSuggestions() {
    final suggestions = <String, String>{};
    
    // Add platform-specific suggestions
    if (Platform.isAndroid) {
      suggestions['platform'] = 'Android';
    } else if (Platform.isIOS) {
      suggestions['platform'] = 'iOS';
    }
    
    // Add common CTU courses
    suggestions['courses'] = 'Bachelor of Science in Information Technology,Bachelor of Science in Computer Engineering,Bachelor of Science in Civil Engineering,Bachelor of Science in Mechanical Engineering,Bachelor of Science in Electrical Engineering,Bachelor of Science in Electronics Engineering,Bachelor of Science in Industrial Technology,Bachelor of Secondary Education,Bachelor of Elementary Education';
    
    // Add CTU campuses
    suggestions['campuses'] = 'Cebu City Campus,Main Campus,Danao Campus,Barili Campus,Moalboal Campus,Argao Campus,Carmen Campus,Oslob Campus,Tabogon Campus,Tabuelan Campus,San Francisco Campus,Tuburan Campus';
    
    // Add academic years
    suggestions['years'] = 'First Year,Second Year,Third Year,Fourth Year,Fifth Year';
    
    return suggestions;
  }

  // Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate student ID format (assuming CTU format)
  bool isValidStudentId(String studentId) {
    // CTU student IDs typically follow patterns like "2020-12345" or "CTU-2020-12345"
    return RegExp(r'^\d{4}-\d{5}$|^CTU-\d{4}-\d{5}$').hasMatch(studentId);
  }

  // Get suggested email domain
  String get suggestedEmailDomain {
    return 'ctu.edu.ph'; // CTU official email domain
  }
}
