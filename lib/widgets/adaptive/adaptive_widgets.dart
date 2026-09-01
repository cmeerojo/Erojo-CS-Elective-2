import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/dashboard_data.dart';

/// Provider to allow toggling or auto-detecting platform styling across the tree.
class AdaptivePlatformScope extends InheritedWidget {
  final TargetPlatformMode mode;
  final ValueChanged<TargetPlatformMode> onModeChanged;

  const AdaptivePlatformScope({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required super.child,
  });

  static AdaptivePlatformScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AdaptivePlatformScope>();
    if (scope == null) {
      throw FlutterError('AdaptivePlatformScope.of() called with no AdaptivePlatformScope in context');
    }
    return scope;
  }

  static TargetPlatformMode getPlatformMode(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AdaptivePlatformScope>();
    return scope?.mode ?? TargetPlatformMode.auto;
  }

  bool isCupertino(BuildContext context) {
    if (mode == TargetPlatformMode.ios) return true;
    if (mode == TargetPlatformMode.android || mode == TargetPlatformMode.web) return false;
    // Auto:
    final target = Theme.of(context).platform;
    return target == TargetPlatform.iOS || target == TargetPlatform.macOS;
  }

  bool isWeb(BuildContext context) {
    if (mode == TargetPlatformMode.web) return true;
    if (mode == TargetPlatformMode.ios || mode == TargetPlatformMode.android) return false;
    return kIsWeb;
  }

  @override
  bool updateShouldNotify(AdaptivePlatformScope oldWidget) {
    return mode != oldWidget.mode;
  }
}

/// Adaptive Icon widget switching between CupertinoIcons and Material Icons
class AdaptiveIcon extends StatelessWidget {
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final double? size;
  final Color? color;

  const AdaptiveIcon({
    super.key,
    required this.materialIcon,
    required this.cupertinoIcon,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isIos = AdaptivePlatformScope.of(context).isCupertino(context);
    return Icon(
      isIos ? cupertinoIcon : materialIcon,
      size: size,
      color: color,
    );
  }
}

/// Adaptive Switch widget swapping Material 3 Switch with CupertinoSwitch
class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isIos = AdaptivePlatformScope.of(context).isCupertino(context);
    if (isIos) {
      return CupertinoSwitch(
        value: value,
        activeTrackColor: const Color(0xFF0284C7),
        onChanged: onChanged,
      );
    }
    return Switch(
      value: value,
      activeThumbColor: Colors.white,
      activeTrackColor: const Color(0xFF0284C7),
      onChanged: onChanged,
    );
  }
}

/// Adaptive Slider widget swapping Material Slider with CupertinoSlider
class AdaptiveSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const AdaptiveSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isIos = AdaptivePlatformScope.of(context).isCupertino(context);
    if (isIos) {
      return CupertinoSlider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        activeColor: const Color(0xFF0284C7),
        onChanged: onChanged,
      );
    }
    return Slider(
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      activeColor: const Color(0xFF0284C7),
      onChanged: onChanged,
    );
  }
}

/// Adaptive Button widget swapping Material FilledButton with CupertinoButton
class AdaptiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final EdgeInsetsGeometry? padding;

  const AdaptiveButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isSecondary = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isIos = AdaptivePlatformScope.of(context).isCupertino(context);
    if (isIos) {
      if (isSecondary) {
        return CupertinoButton(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(10),
          onPressed: onPressed,
          child: DefaultTextStyle(
            style: const TextStyle(
              color: CupertinoColors.label,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            child: child,
          ),
        );
      }
      return CupertinoButton.filled(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        borderRadius: BorderRadius.circular(10),
        onPressed: onPressed,
        child: child,
      );
    }

    if (isSecondary) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: Color(0xFF94A3B8)),
        ),
        onPressed: onPressed,
        child: child,
      );
    }

    return FilledButton(
      style: FilledButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

/// Wireframe Card that adapts its style (borders/corners/hover states) depending on platform
class AdaptiveWireframeCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final String? tagLabel;
  final Color? borderColor;

  const AdaptiveWireframeCard({
    super.key,
    required this.child,
    this.padding,
    this.tagLabel,
    this.borderColor,
  });

  @override
  State<AdaptiveWireframeCard> createState() => _AdaptiveWireframeCardState();
}

class _AdaptiveWireframeCardState extends State<AdaptiveWireframeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final scope = AdaptivePlatformScope.of(context);
    final isIos = scope.isCupertino(context);
    final isWeb = scope.isWeb(context);

    final baseBorderColor = widget.borderColor ??
        (isIos ? const Color(0xFFD1D5DB) : const Color(0xFFCBD5E1));
    final activeBorderColor = _isHovered && isWeb ? const Color(0xFF0284C7) : baseBorderColor;

    final borderRadius = BorderRadius.circular(isIos ? 14 : 8);

    Widget content = Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isIos ? CupertinoColors.systemBackground : Colors.white,
        borderRadius: borderRadius,
        border: Border.all(
          color: activeBorderColor,
          width: _isHovered && isWeb ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (_isHovered && isWeb)
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          else if (!isIos)
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Stack(
        children: [
          widget.child,
          if (widget.tagLabel != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 0.8),
                ),
                child: Text(
                  widget.tagLabel!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (isWeb) {
      return MouseRegion(
        cursor: SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: content,
      );
    }

    return content;
  }
}
