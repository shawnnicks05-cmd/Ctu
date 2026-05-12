import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys used in SharedPreferences
abstract class AuthKeys {
  static const loggedIn = 'auth_logged_in';
  static const email = 'auth_user_email';
  static const users = 'auth_users';
}

/// Default demo accounts
const Map<String, String> kDemoUserPassword = {
  'kassandra.canama@ctu.edu.ph': 'Ctu2024!',
  'student@ctu.edu.ph': 'student123',
};

class AuthService extends ChangeNotifier {
  AuthService._();

  static final AuthService instance = AuthService._();

  bool _authenticated = false;
  String? _email;

  bool get isAuthenticated => _authenticated;
  String? get userEmail => _email;

  /// All registered accounts
  final Map<String, String> _accounts = {
    ...kDemoUserPassword,
  };

  /// Initialize auth state
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    _authenticated = prefs.getBool(AuthKeys.loggedIn) ?? false;

    _email = prefs.getString(AuthKeys.email);

    /// Load saved users
    final savedUsers = prefs.getStringList(AuthKeys.users) ?? [];

    for (final user in savedUsers) {
      final parts = user.split('|');

      if (parts.length == 2) {
        _accounts[parts[0]] = parts[1];
      }
    }

    notifyListeners();
  }

  /// Login
  Future<bool> signInWithPassword(
    String email,
    String password,
  ) async {
    final e = email.trim().toLowerCase();

    final expected = _accounts[e];

    if (expected == null || expected != password) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(AuthKeys.loggedIn, true);

    await prefs.setString(AuthKeys.email, e);

    _authenticated = true;
    _email = e;

    notifyListeners();

    return true;
  }

  /// Create Account
  Future<bool> createAccount(
    String email,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final e = email.trim().toLowerCase();

    /// Check if account already exists
    if (_accounts.containsKey(e)) {
      return false;
    }

    /// Save new account
    _accounts[e] = password;

    /// Convert map to list
    final userList = _accounts.entries
        .map((entry) => '${entry.key}|${entry.value}')
        .toList();

    /// Save locally
    await prefs.setStringList(
      AuthKeys.users,
      userList,
    );

    return true;
  }

  /// Logout
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(AuthKeys.loggedIn);

    await prefs.remove(AuthKeys.email);

    _authenticated = false;
    _email = null;

    notifyListeners();
  }
}
