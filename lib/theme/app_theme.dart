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
  static const Color pokedexScreenBg = Color(0xFFF4F6F9);

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
      scaffoldBackgroundColor: pokedexScreenBg,
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
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFFE8EAF0),
            width: 1.5,
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