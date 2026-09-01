import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../adaptive/adaptive_widgets.dart';

class WireframeQuickControls extends StatefulWidget {
  const WireframeQuickControls({super.key});

  @override
  State<WireframeQuickControls> createState() => _WireframeQuickControlsState();
}

class _WireframeQuickControlsState extends State<WireframeQuickControls> {
  bool _autoScaling = true;
  bool _turboMode = false;
  double _throttleRate = 0.75;

  void _showAdaptiveActionDialog(BuildContext context, String actionTitle, String message) {
    final scope = AdaptivePlatformScope.of(context);
    final isIos = scope.isCupertino(context);

    if (isIos) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(actionTitle),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(message),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(actionTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveWireframeCard(
      tagLabel: 'CONTROLS: ADAPTIVE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune_rounded, size: 18, color: Color(0xFF0284C7)),
              SizedBox(width: 6),
              Text(
                'SYSTEM CONTROLS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),

          // Switch 1: Auto Scaling
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto-Scaling Engine',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Dynamic replica management',
                      style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AdaptiveSwitch(
                value: _autoScaling,
                onChanged: (val) => setState(() => _autoScaling = val),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Switch 2: Turbo Mode
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Turbo Mode',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Low-latency edge caching',
                      style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AdaptiveSwitch(
                value: _turboMode,
                onChanged: (val) => setState(() => _turboMode = val),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Slider: Bandwidth Throttle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bandwidth Limit',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${(_throttleRate * 100).toInt()}%',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              AdaptiveSlider(
                value: _throttleRate,
                onChanged: (val) => setState(() => _throttleRate = val),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Buttons
          Row(
            children: [
              Expanded(
                child: AdaptiveButton(
                  isSecondary: true,
                  onPressed: () {
                    _showAdaptiveActionDialog(
                      context,
                      'Cache Purged',
                      'Edge CDN caches have been invalidated successfully.',
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Purge Cache',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AdaptiveButton(
                  onPressed: () {
                    _showAdaptiveActionDialog(
                      context,
                      'Diagnostics Started',
                      'Full cluster self-test initiated. Status reports will stream to event log.',
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Run Check',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
