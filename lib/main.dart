import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';

// Entry point of the Flutter application.
void main() {
  // Wraps the root ShopApp widget inside a ChangeNotifierProvider.
  // Placing Provider at the top level of the widget tree ensures the CartProvider
  // state (items, quantity, total) is globally accessible from any screen in the app.
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const ShopApp(),
    ),
  );
}

class ShopApp extends StatefulWidget {
  const ShopApp({super.key});

  @override
  State<ShopApp> createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> {
  ThemeMode _themeMode = ThemeMode.light;
  late final router = createAppRouter(onToggleTheme: _toggleTheme);

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'JDM Showroom',
      themeMode: _themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
