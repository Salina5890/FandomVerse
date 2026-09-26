import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fandom_verse/app/app.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const FandomVerseApp());
    // Verify app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
