import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tinsu_shops/app/app.dart';
import 'package:tinsu_shops/features/auth/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('App renders splash screen without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: TinsuShopsApp()),
    );
    // Pump one frame — splash screen should be shown immediately.
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
