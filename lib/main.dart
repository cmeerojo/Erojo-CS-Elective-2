import 'package:flutter/material.dart';
import 'screens/pokedex_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex FireRed',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.fireRedTheme,
      home: const PokedexScreen(),
    );
  }
}
