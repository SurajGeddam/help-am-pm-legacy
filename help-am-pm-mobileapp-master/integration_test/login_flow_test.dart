import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:helpampm/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow Integration Tests', () {
    testWidgets('should launch app and show login screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Should show login screen
      expect(find.text('LOG IN'), findsOneWidget);
    });

    testWidgets('should show validation error for empty fields', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Try to login without entering credentials
      await tester.tap(find.text('LOG IN'));
      await tester.pumpAndSettle();

      // Should show validation error
      expect(find.text('Please enter email'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(find.byType(TextField).first, 'invalid-email');
      await tester.enterText(find.byType(TextField).last, 'password123');
      
      await tester.tap(find.text('LOG IN'));
      await tester.pumpAndSettle();

      // Should show email validation error
      expect(find.text('Please enter valid email'), findsOneWidget);
    });

    testWidgets('should show validation error for short password', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Enter valid email but short password
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, '123');
      
      await tester.tap(find.text('LOG IN'));
      await tester.pumpAndSettle();

      // Should show password validation error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('should navigate to forgot password screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap forgot password link
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Should navigate to forgot password screen
      expect(find.text('FORGOT PASSWORD'), findsOneWidget);
    });

    testWidgets('should navigate to register screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap register link
      await tester.tap(find.text("Don't have an account?"));
      await tester.pumpAndSettle();

      // Should navigate to register screen
      expect(find.text('REGISTER'), findsOneWidget);
    });

    testWidgets('should attempt login with valid credentials', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Enter valid credentials
      await tester.enterText(find.byType(TextField).first, 'geddamsuraj@gmail.com');
      await tester.enterText(find.byType(TextField).last, 'Test1234!');
      
      await tester.tap(find.text('LOG IN'));
      await tester.pumpAndSettle();

      // Should attempt login (may fail if backend not running, but should not show validation errors)
      expect(find.text('Please enter email'), findsNothing);
      expect(find.text('Please enter valid email'), findsNothing);
      expect(find.text('Password must be at least 6 characters'), findsNothing);
    });
  });
} 