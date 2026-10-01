import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PokedexBackground extends StatelessWidget {
  final Widget child;

  const PokedexBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.fireRedBackgroundGradient,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Icon(
              Icons.catching_pokemon,
              size: 260,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Icon(
              Icons.catching_pokemon,
              size: 320,
              color: Colors.black.withValues(alpha: 0.12),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2024),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF383A40),
                    width: 3.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
