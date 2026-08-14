// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_app/main.dart';

void main() {
  group('Todo App Tests', () {
    testWidgets('App launches and displays empty state',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const TodoApp());

      // Verify that app title is displayed
      expect(find.text('My Todos'), findsOneWidget);

      // Verify empty state message
      expect(find.text('No tasks yet!'), findsOneWidget);
      expect(find.text('Add a task to get started'), findsOneWidget);
    });

    testWidgets('Can add a new todo item', (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      // Find input field and add button
      final textField = find.byType(TextField);
      final addButton = find.byIcon(Icons.add);

      expect(textField, findsOneWidget);
      expect(addButton, findsOneWidget);

      // Enter text in the field
      await tester.enterText(textField, 'Test Todo Item');
      await tester.pump();

      // Tap add button
      await tester.tap(addButton);
      await tester.pump();

      // Verify the todo item was added
      expect(find.text('Test Todo Item'), findsOneWidget);
    });

    testWidgets('Can toggle todo completion status',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      // Add a todo item
      final textField = find.byType(TextField);
      final addButton = find.byIcon(Icons.add);

      await tester.enterText(textField, 'Complete me');
      await tester.tap(addButton);
      await tester.pump();

      // Find and tap the checkbox
      final checkbox = find.byType(Checkbox).first;
      await tester.tap(checkbox);
      await tester.pump();

      // Verify strikethrough is applied
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.style?.decoration == TextDecoration.lineThrough,
        ),
        findsOneWidget,
      );
    });

    testWidgets('Can delete a todo item', (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      // Add a todo item
      final textField = find.byType(TextField);
      final addButton = find.byIcon(Icons.add);

      await tester.enterText(textField, 'Delete me');
      await tester.tap(addButton);
      await tester.pump();

      // Find and tap delete button
      final deleteButton = find.byIcon(Icons.delete).first;
      await tester.tap(deleteButton);
      await tester.pump();

      // Verify the item was deleted
      expect(find.text('Delete me'), findsNothing);
    });

    testWidgets('Task counter updates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      final textField = find.byType(TextField);
      final addButton = find.byIcon(Icons.add);

      // Add first item
      await tester.enterText(textField, 'Task 1');
      await tester.tap(addButton);
      await tester.pump();

      // Add second item
      await tester.enterText(textField, 'Task 2');
      await tester.tap(addButton);
      await tester.pump();

      // Verify task counter shows 2
      expect(find.text('2'), findsWidgets);
    });
  });
}
