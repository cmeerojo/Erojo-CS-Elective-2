import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/dashboard_data.dart';

void main() {
  group('Responsive Dashboard Layout Tests (LayoutBuilder)', () {
    testWidgets('Renders Mobile layout when screen width < 600px', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('MOBILE LAYOUT'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('TOTAL REVENUE'), findsOneWidget);
      expect(find.text('ACTIVE USERS'), findsOneWidget);
    });

    testWidgets('Renders Tablet layout when screen width is between 600px and 1023px', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('TABLET LAYOUT'), findsOneWidget);
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.text('NODE HEALTH STATUS'), findsOneWidget);
    });

    testWidgets('Renders Desktop layout when screen width >= 1024px', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('DESKTOP LAYOUT'), findsOneWidget);
      expect(find.text('WIREFRAME OS'), findsOneWidget);
      expect(find.text('ACTIVE WORKER NODES'), findsOneWidget);
      expect(find.text('node-cluster-alpha-01'), findsOneWidget);
    });
  });

  group('Adaptive Platform Tests (Cupertino vs Material)', () {
    testWidgets('Swaps to Cupertino widgets when iOS mode is active', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MyApp(initialPlatformMode: TargetPlatformMode.ios),
      );
      await tester.pumpAndSettle();

      // Mobile with iOS mode should render CupertinoNavigationBar and CupertinoTabBar
      expect(find.byType(CupertinoNavigationBar), findsOneWidget);
      expect(find.byType(CupertinoTabBar), findsOneWidget);
      expect(find.byType(CupertinoSwitch), findsWidgets);
      expect(find.byType(CupertinoSlider), findsWidgets);
    });

    testWidgets('Swaps to Material widgets when Android mode is active', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MyApp(initialPlatformMode: TargetPlatformMode.android),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(Switch), findsWidgets);
      expect(find.byType(Slider), findsWidgets);
    });
  });
}
