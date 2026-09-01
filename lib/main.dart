import 'package:flutter/material.dart';
import 'models/dashboard_data.dart';
import 'views/dashboard_view.dart';
import 'widgets/adaptive/adaptive_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final TargetPlatformMode initialPlatformMode;

  const MyApp({
    super.key,
    this.initialPlatformMode = TargetPlatformMode.auto,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TargetPlatformMode _platformMode;

  @override
  void initState() {
    super.initState();
    _platformMode = widget.initialPlatformMode;
  }

  void _updatePlatformMode(TargetPlatformMode mode) {
    setState(() {
      _platformMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine effective target platform for MaterialApp theme
    TargetPlatform? platformOverride;
    if (_platformMode == TargetPlatformMode.ios) {
      platformOverride = TargetPlatform.iOS;
    } else if (_platformMode == TargetPlatformMode.android) {
      platformOverride = TargetPlatform.android;
    } else if (_platformMode == TargetPlatformMode.web) {
      platformOverride = TargetPlatform.windows; // Desktop style
    }

    return AdaptivePlatformScope(
      mode: _platformMode,
      onModeChanged: _updatePlatformMode,
      child: MaterialApp(
        title: 'Responsive & Adaptive Wireframe Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          platform: platformOverride,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0284C7),
            primary: const Color(0xFF0F172A),
            surface: const Color(0xFFF8FAFC),
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          fontFamily: 'sans-serif',
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
        home: const DashboardView(),
      ),
    );
  }
}
