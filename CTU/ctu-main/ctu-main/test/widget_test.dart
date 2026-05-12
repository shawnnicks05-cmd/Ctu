// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ssc/main.dart';
import 'package:ssc/screens/loading_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App shows sign-in when not logged in', (WidgetTester tester) async {
    // Pump the widget without waiting for settle to avoid timeout
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    
    // Give a short time for initialization
    await tester.pump(const Duration(milliseconds: 500));
    
    // Check if we can find the loading screen or login screen
    final hasLoadingScreen = find.byType(AppLoadingScreen).evaluate().isNotEmpty;
    final hasSignIn = find.text('Sign In').evaluate().isNotEmpty;
    
    // If still on loading screen, pump a bit more
    if (hasLoadingScreen && !hasSignIn) {
      await tester.pump(const Duration(milliseconds: 1000));
    }
    
    // Now check for login screen elements
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.textContaining('Sign in with your CTU email'), findsOneWidget);
  });
}
