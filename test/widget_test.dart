// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budget_track/main.dart';

void main() {
  testWidgets('Budget Tracker app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BudgetTrackerApp());

    // Verify that initial budget setup screen is shown
    expect(find.text('Set Your Initial Budget'), findsOneWidget);
    expect(find.text('Start Tracking'), findsOneWidget);
  });

  testWidgets('Can set initial budget', (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetTrackerApp());

    // Enter budget amount
    await tester.enterText(find.byType(TextField), '5000');
    await tester.tap(find.text('Start Tracking'));
    await tester.pumpAndSettle();

    // Verify budget tracker screen is shown
    expect(find.text('Initial Budget'), findsOneWidget);
    expect(find.text('Add New Expense'), findsOneWidget);
  });

  testWidgets('Shows validation error for empty budget',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetTrackerApp());

    // Tap without entering budget
    await tester.tap(find.text('Start Tracking'));
    await tester.pumpAndSettle();

    // Verify error dialog appears
    expect(find.text('Invalid Input'), findsOneWidget);
    expect(find.text('Please enter a valid budget amount greater than 0.'),
        findsOneWidget);
  });

  testWidgets('Can add an expense', (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetTrackerApp());

    // Set budget
    await tester.enterText(find.byType(TextField), '5000');
    await tester.tap(find.text('Start Tracking'));
    await tester.pumpAndSettle();

    // Add expense
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), 'Lunch');
    await tester.enterText(textFields.at(1), '150');
    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();

    // Verify expense is added
    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text('₱150.00'), findsOneWidget);
    expect(find.text('Total: 1'), findsOneWidget);
  });

  testWidgets('Shows validation error for empty expense',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetTrackerApp());

    // Set budget
    await tester.enterText(find.byType(TextField), '5000');
    await tester.tap(find.text('Start Tracking'));
    await tester.pumpAndSettle();

    // Try to add expense without filling fields
    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();

    // Verify error dialog appears
    expect(find.text('Invalid Input'), findsOneWidget);
    expect(find.text('Please enter valid expense name and amount.'),
        findsOneWidget);
  });

  testWidgets('Calculates remaining budget correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetTrackerApp());

    // Set budget
    await tester.enterText(find.byType(TextField), '1000');
    await tester.tap(find.text('Start Tracking'));
    await tester.pumpAndSettle();

    // Add expense
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), 'Shopping');
    await tester.enterText(textFields.at(1), '300');
    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();

    // Verify calculations
    expect(find.text('₱1000.00'), findsOneWidget); // Initial budget
    expect(find.text('₱300.00'), findsOneWidget); // Spent
    expect(find.text('₱700.00'), findsOneWidget); // Remaining
  });

  testWidgets('Shows budget status messages', (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetTrackerApp());

    // Set budget
    await tester.enterText(find.byType(TextField), '1000');
    await tester.tap(find.text('Start Tracking'));
    await tester.pumpAndSettle();

    // Should show "Budget OK" initially
    expect(find.text('Budget OK'), findsOneWidget);

    // Add expense that uses 60% of budget
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), 'Shopping');
    await tester.enterText(textFields.at(1), '600');
    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();

    // Should show "Budget Half Used"
    expect(find.text('Budget Half Used'), findsOneWidget);
  });

  testWidgets('Shows over budget warning', (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetTrackerApp());

    // Set budget
    await tester.enterText(find.byType(TextField), '500');
    await tester.tap(find.text('Start Tracking'));
    await tester.pumpAndSettle();

    // Add expense that exceeds budget
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), 'Emergency');
    await tester.enterText(textFields.at(1), '800');
    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();

    // Should show "Over Budget!"
    expect(find.text('Over Budget!'), findsOneWidget);
  });

  testWidgets('Category dropdown works', (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetTrackerApp());

    // Set budget
    await tester.enterText(find.byType(TextField), '5000');
    await tester.tap(find.text('Start Tracking'));
    await tester.pumpAndSettle();

    // Verify dropdown shows Food by default
    expect(find.text('Food'), findsOneWidget);

    // Tap dropdown
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    // Verify all categories are available
    expect(find.text('Transport').last, findsOneWidget);
    expect(find.text('Entertainment').last, findsOneWidget);
    expect(find.text('Shopping').last, findsOneWidget);
    expect(find.text('Bills').last, findsOneWidget);
    expect(find.text('Others').last, findsOneWidget);
  });

  testWidgets('Displays empty state when no expenses',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetTrackerApp());

    // Set budget
    await tester.enterText(find.byType(TextField), '5000');
    await tester.tap(find.text('Start Tracking'));
    await tester.pumpAndSettle();

    // Verify empty state is shown
    expect(find.text('No expenses yet'), findsOneWidget);
    expect(find.byIcon(Icons.inbox), findsOneWidget);
  });

  testWidgets('Multiple expenses display correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetTrackerApp());

    // Set budget
    await tester.enterText(find.byType(TextField), '5000');
    await tester.tap(find.text('Start Tracking'));
    await tester.pumpAndSettle();

    // Add first expense
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), 'Breakfast');
    await tester.enterText(textFields.at(1), '100');
    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();

    // Add second expense
    await tester.enterText(textFields.at(0), 'Taxi');
    await tester.enterText(textFields.at(1), '200');
    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();

    // Verify both expenses are shown
    expect(find.text('Breakfast'), findsOneWidget);
    expect(find.text('Taxi'), findsOneWidget);
    expect(find.text('Total: 2'), findsOneWidget);
    expect(find.text('₱300.00'), findsOneWidget); // Total spent
  });
}
