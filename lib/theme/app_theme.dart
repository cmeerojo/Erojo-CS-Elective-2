import 'package:flutter/material.dart';

class AppTheme {
  static const Color fireRedPrimary = Color(0xFFC72424);
  static const Color fireRedDark = Color(0xFF8E1111);
  static const Color fireRedFlame = Color(0xFFFF6D00);
  static const Color fireRedAccent = Color(0xFFFF9E80);

  static const Color sensorBlue = Color(0xFF00E5FF);
  static const Color sensorRed = Color(0xFFFF1744);
  static const Color sensorYellow = Color(0xFFFFD600);
  static const Color sensorGreen = Color(0xFF00E676);

  static const Color pokedexDark = Color(0xFF212124);
  static const Color pokedexScreenFrame = Color(0xFF2D2E33);
  static const Color pokedexScreenBg = Color(0xFF1E2024);

  static const LinearGradient fireRedBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFD32F2F),
      Color(0xFFB71C1C),
      Color(0xFF7F0000),
    ],
  );

  static const Map<String, Color> typeColors = {
    'fire': Color(0xFFFF5722),
    'water': Color(0xFF2196F3),
    'grass': Color(0xFF4CAF50),
    'electric': Color(0xFFFFB300),
    'psychic': Color(0xFFE91E63),
    'ice': Color(0xFF00BCD4),
    'dragon': Color(0xFF3F51B5),
    'dark': Color(0xFF424242),
    'fairy': Color(0xFFF48FB1),
    'normal': Color(0xFF9E9E9E),
    'fighting': Color(0xFFC62828),
    'flying': Color(0xFF0288D1),
    'poison': Color(0xFF9C27B0),
    'ground': Color(0xFF795548),
    'rock': Color(0xFF6D4C41),
    'bug': Color(0xFF8BC34A),
    'ghost': Color(0xFF5E35B1),
    'steel': Color(0xFF607D8B),
  };

  static Color getTypeColor(String type) {
    return typeColors[type.toLowerCase()] ?? const Color(0xFF78909C);
  }

  static ThemeData get fireRedTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: fireRedPrimary,
      primary: fireRedPrimary,
      secondary: fireRedFlame,
      surface: Colors.white,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: fireRedDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: fireRedPrimary,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1.2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: fireRedPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}