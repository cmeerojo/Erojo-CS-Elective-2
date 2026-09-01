import 'package:flutter/material.dart';
import '../../models/dashboard_data.dart';
import '../adaptive/adaptive_widgets.dart';

class WireframeHeaderBanner extends StatelessWidget {
  final double currentWidth;
  final String layoutName;

  const WireframeHeaderBanner({
    super.key,
    required this.currentWidth,
    required this.layoutName,
  });

  @override
  Widget build(BuildContext context) {
    final scope = AdaptivePlatformScope.of(context);
    final isIos = scope.isCupertino(context);
    final isWeb = scope.isWeb(context);

    String platformTag;
    if (scope.mode == TargetPlatformMode.auto) {
      if (isWeb) {
        platformTag = 'WEB (Auto-detected)';
      } else if (isIos) {
        platformTag = 'iOS / CUPERTINO (Auto-detected)';
      } else {
        platformTag = 'ANDROID / MATERIAL (Auto-detected)';
      }
    } else {
      platformTag = scope.mode.label.toUpperCase();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'INSPECTOR CONSOLE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              _buildPlatformDropdown(context, scope),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFF334155)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildBadge('📐 RESPONSIVE', '$layoutName (${currentWidth.toInt()}px)', const Color(0xFF38BDF8)),
              _buildBadge('⚡ ADAPTIVE', platformTag, const Color(0xFFA78BFA)),
              const Text(
                '• Resize window to test Responsive • Switch Mode to test Adaptive',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, String value, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: accentColor.withAlpha(80)),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformDropdown(BuildContext context, AdaptivePlatformScope scope) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF475569)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TargetPlatformMode>(
          value: scope.mode,
          dropdownColor: const Color(0xFF1E293B),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
          onChanged: (newMode) {
            if (newMode != null) {
              scope.onModeChanged(newMode);
            }
          },
          items: TargetPlatformMode.values.map((mode) {
            return DropdownMenuItem<TargetPlatformMode>(
              value: mode,
              child: Text(
                mode.label,
                style: const TextStyle(fontSize: 11, color: Colors.white),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
