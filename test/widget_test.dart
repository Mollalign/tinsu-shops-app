import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MaterialApp renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Text('Tinsu-Shops')),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Tinsu-Shops'), findsOneWidget);
  });
}
