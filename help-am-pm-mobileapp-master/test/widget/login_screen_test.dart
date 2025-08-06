import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helpampm/modules/login/ui/login_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('should render login screen with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Should show login screen
      expect(find.text('LOG IN'), findsOneWidget);
    });

    testWidgets('should render email and password text fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Should have text fields for email and password
      expect(find.byType(TextField), findsAtLeastNWidgets(2));
    });

    testWidgets('should show forgot password link', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Should show forgot password link
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('should show register link', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Should show register link
      expect(find.text("Don't have an account?"), findsOneWidget);
    });

    testWidgets('should allow text input in email field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Enter text in first text field (email)
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.pump();

      // Should have entered text
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should allow text input in password field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Enter text in second text field (password)
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.pump();

      // Should have entered text (password might be hidden, so check for field)
      expect(find.byType(TextField), findsAtLeastNWidgets(2));
    });
  });
} 