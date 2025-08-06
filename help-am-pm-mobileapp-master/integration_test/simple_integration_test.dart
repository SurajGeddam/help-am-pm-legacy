import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Simple Integration Tests', () {
    testWidgets('should render a simple app screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Test App'),
            ),
            body: const Center(
              child: Text('Welcome to the test app'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test App'), findsOneWidget);
      expect(find.text('Welcome to the test app'), findsOneWidget);
    });

    testWidgets('should handle navigation between screens', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
            ),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    tester.element(find.byType(ElevatedButton)),
                    MaterialPageRoute(
                      builder: (context) => const Scaffold(
                        body: Center(
                          child: Text('Second Screen'),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Navigate'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show home screen
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Navigate'), findsOneWidget);

      // Tap navigate button
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // Should show second screen
      expect(find.text('Second Screen'), findsOneWidget);
    });

    testWidgets('should handle form input and validation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    onChanged: (value) {
                      // Simulate validation
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Simulate form submission
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show form elements
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);

      // Enter text in fields
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.pump();

      // Should have entered text
      expect(find.text('test@example.com'), findsOneWidget);
    });
  });
} 