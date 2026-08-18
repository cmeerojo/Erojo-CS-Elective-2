import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('shows the fruit list and navigates to a fruit detail route',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Fruit List'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);

    await tester.tap(find.text('Apple'));
    await tester.pumpAndSettle();

    expect(find.text('Apple'), findsWidgets);
    expect(find.text('🍎'), findsOneWidget);
  });
}
