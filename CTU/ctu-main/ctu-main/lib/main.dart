import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'screens/auth/login_screen.dart';
import 'screens/main_shell.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
