import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

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

// Root application widget defined as a StatefulWidget.
// It is stateful so it can hold and toggle the global `_themeMode` state (Light vs Dark mode).
class ShopApp extends StatefulWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  State<ShopApp> createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> {
  // State variable storing the active theme mode (defaults to Light mode)
  ThemeMode _themeMode = ThemeMode.light;

  // Toggles theme between Light and Dark modes.
  // Calling setState triggers a rebuild of MaterialApp with the new themeMode.
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Navigation 2.0 implementation using the `go_router` package.
  // Defines all available routes and paths in the application declaratively.
  late final GoRouter _router = GoRouter(
    initialLocation: '/', // App opens on the Home screen route
    routes: [
      // Route 1: Home Screen (Product Grid)
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(onToggleTheme: _toggleTheme),
      ),
      // Route 2: Product Detail Screen (with dynamic path parameter :id)
      GoRoute(
        path: '/car/:id',
        builder: (context, state) {
          // Extracts the car ID from URL parameters (e.g., /car/1 -> id = '1')
          final carId = state.pathParameters['id']!;
          return DetailScreen(
            carId: carId,
            onViewCart: () => _router.push('/cart'),
          );
        },
      ),
      // Route 3: Shopping Cart Screen
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      // Route 4: Checkout Confirmation Screen
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router configures Flutter to use Navigation 2.0 via routerConfig
    return MaterialApp.router(
      title: 'JDM Showroom',
      themeMode: _themeMode, // Applied theme mode state (Light or Dark)
      
      // Global ThemeData for Light Mode - applies consistent colors across all screens
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      
      // Global ThemeData for Dark Mode - automatically used when _themeMode is dark
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      
      // Plugs in the Navigation 2.0 GoRouter configuration
      routerConfig: _router,
    );
  }
}
