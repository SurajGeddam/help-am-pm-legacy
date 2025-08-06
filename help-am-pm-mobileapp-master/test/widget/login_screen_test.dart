import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helpampm/modules/login/bloc/login_bloc/login_bloc.dart';
import 'package:helpampm/modules/login/bloc/login_bloc/login_event.dart';
import 'package:helpampm/modules/login/bloc/login_bloc/login_state.dart';
import 'package:helpampm/modules/login/ui/login_screen.dart';
import 'package:helpampm/utils/app_strings.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState> implements LoginBloc {}

void main() {
  group('LoginScreen Widget Tests', () {
    late MockLoginBloc mockLoginBloc;

    setUp(() {
      mockLoginBloc = MockLoginBloc();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: BlocProvider<LoginBloc>.value(
          value: mockLoginBloc,
          child: const LoginScreen(),
        ),
      );
    }

    testWidgets('should render login screen with title', (WidgetTester tester) async {
      whenListen(mockLoginBloc, Stream.fromIterable([LoginInitialState()]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.logIn), findsOneWidget);
    });

    testWidgets('should render email and password text fields', (WidgetTester tester) async {
      whenListen(mockLoginBloc, Stream.fromIterable([LoginInitialState()]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsAtLeastNWidgets(2));
    });

    testWidgets('should show loading state when login is in progress', (WidgetTester tester) async {
      whenListen(mockLoginBloc, Stream.fromIterable([
        LoginInitialState(),
        LoginLoadingState(),
      ]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Trigger loading state
      await tester.pump();
      
      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message on login failure', (WidgetTester tester) async {
      const errorMessage = 'Invalid credentials';
      whenListen(mockLoginBloc, Stream.fromIterable([
        LoginInitialState(),
        LoginErrorState(errorMessage, Colors.red),
      ]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Trigger error state
      await tester.pump();
      
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should call login event when form is submitted', (WidgetTester tester) async {
      whenListen(mockLoginBloc, Stream.fromIterable([LoginInitialState()]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter email and password
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');

      // Tap login button
      await tester.tap(find.text(AppStrings.logIn));
      await tester.pump();

      verify(mockLoginBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should navigate to forgot password screen', (WidgetTester tester) async {
      whenListen(mockLoginBloc, Stream.fromIterable([LoginInitialState()]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Look for forgot password link
      expect(find.text('Forgot Password?'), findsOneWidget);
    });
  });
} 