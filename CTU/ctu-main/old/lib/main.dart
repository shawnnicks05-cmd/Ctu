import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'services/auth_service.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'CTU Smart Calendar',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          // lib/main.dart
          home: AuthService.instance.isAuthenticated
              ? const MainShell()
              : const LoginScreen(),
        );
      },
    );
  }
}
