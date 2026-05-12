import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'screens/auth/login_screen.dart';
import 'screens/main_shell.dart';
import 'screens/loading_screen.dart';
import 'services/auth_provider.dart';
import 'services/ctu_calendar_service.dart';
import 'services/notification_service.dart';
import 'services/autofill_service.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with proper configuration for web
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyC3fxA9s9WuJkLj3TsIjqPTKS0AEjPYETM",
          authDomain: "ctu-smart-school-calendar.firebaseapp.com",
          projectId: "ctu-smart-school-calendar",
          storageBucket: "ctu-smart-school-calendar.firebasestorage.app",
          messagingSenderId: "504460775226",
          appId: "1:504460775226:web:40aa281ade3dc47f754a03",
          measurementId: "G-1Y6R2B8XBB",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Continue without Firebase for development
  }

  // Initialize all services
  CTUCalendarService().initializeEvents();
  await NotificationService().initialize();
  await AutofillService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Firebase is already initialized in main()
      // Calendar service is already initialized in main()

      // Add a small delay to ensure loading screen is visible
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Initialization error: $e');
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        title: 'CTU Smart Calendar',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const AppLoadingScreen(),
      );
    }

    if (_hasError) {
      return MaterialApp(
        title: 'CTU Smart Calendar',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Initialization Error', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Please restart the app', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'CTU Smart Calendar',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            home: authProvider.isAuthenticated
                ? const MainShell()
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}
