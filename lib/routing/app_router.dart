import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/home_screen.dart';

GoRouter createAppRouter({required VoidCallback onToggleTheme}) {
  late final GoRouter router;

  router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(onToggleTheme: onToggleTheme),
      ),
      GoRoute(
        path: '/car/:id',
        builder: (context, state) => DetailScreen(
          carId: state.pathParameters['id']!,
          onViewCart: () => router.push('/cart'),
        ),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
    ],
  );

  return router;
}