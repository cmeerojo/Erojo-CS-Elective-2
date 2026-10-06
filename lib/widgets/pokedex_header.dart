import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PokedexHeader extends StatelessWidget {
  final int count;
  final int totalAvailable;
  final VoidCallback onRefresh;

  const PokedexHeader({
    super.key,
    required this.count,
    required this.onRefresh,
    this.totalAvailable = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppTheme.fireRedPrimary,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.sensorBlue.withValues(alpha: 0.6),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment(-0.3, -0.3),
                    radius: 0.8,
                    colors: [
                      Colors.white,
                      AppTheme.sensorBlue,
                      Color(0xFF007799),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildIndicatorLed(AppTheme.sensorRed),
            const SizedBox(width: 6),
            _buildIndicatorLed(AppTheme.sensorYellow),
            const SizedBox(width: 6),
            _buildIndicatorLed(AppTheme.sensorGreen),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'POKÉDEX',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
                Text(
                  'SHOWING $count OF $totalAvailable',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 22,
              ),
              tooltip: 'Refresh Pokédex',
              onPressed: onRefresh,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorLed(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black26, width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
