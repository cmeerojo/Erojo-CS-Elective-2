import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum TargetPlatformMode {
  auto('Auto (System Default)'),
  ios('iOS / Cupertino'),
  android('Android / Material 3'),
  web('Web / Desktop');

  final String label;
  const TargetPlatformMode(this.label);
}

class MetricItem {
  final String id;
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final List<double> trend;

  const MetricItem({
    required this.id,
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.materialIcon,
    required this.cupertinoIcon,
    required this.trend,
  });
}

class ActivityLogItem {
  final String id;
  final String title;
  final String subtitle;
  final String timestamp;
  final ActivityType type;

  const ActivityLogItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.type,
  });
}

enum ActivityType {
  success,
  warning,
  info;

  Color get color {
    switch (this) {
      case ActivityType.success:
        return const Color(0xFF10B981);
      case ActivityType.warning:
        return const Color(0xFFF59E0B);
      case ActivityType.info:
        return const Color(0xFF3B82F6);
    }
  }

  IconData get materialIcon {
    switch (this) {
      case ActivityType.success:
        return Icons.check_circle_outline_rounded;
      case ActivityType.warning:
        return Icons.warning_amber_rounded;
      case ActivityType.info:
        return Icons.info_outline_rounded;
    }
  }

  IconData get cupertinoIcon {
    switch (this) {
      case ActivityType.success:
        return CupertinoIcons.checkmark_circle;
      case ActivityType.warning:
        return CupertinoIcons.exclamationmark_triangle;
      case ActivityType.info:
        return CupertinoIcons.info_circle;
    }
  }
}

class DashboardData {
  static const List<MetricItem> metrics = [
    MetricItem(
      id: 'revenue',
      title: 'TOTAL REVENUE',
      value: '\$48,290',
      change: '+14.2%',
      isPositive: true,
      materialIcon: Icons.attach_money_rounded,
      cupertinoIcon: CupertinoIcons.money_dollar_circle,
      trend: [0.3, 0.45, 0.4, 0.65, 0.6, 0.8, 0.95],
    ),
    MetricItem(
      id: 'users',
      title: 'ACTIVE USERS',
      value: '2,845',
      change: '+8.1%',
      isPositive: true,
      materialIcon: Icons.people_alt_rounded,
      cupertinoIcon: CupertinoIcons.person_2_fill,
      trend: [0.4, 0.35, 0.5, 0.55, 0.7, 0.65, 0.85],
    ),
    MetricItem(
      id: 'bandwidth',
      title: 'SERVER LOAD',
      value: '64.8%',
      change: '-3.4%',
      isPositive: false,
      materialIcon: Icons.speed_rounded,
      cupertinoIcon: CupertinoIcons.gauge,
      trend: [0.7, 0.8, 0.75, 0.6, 0.7, 0.68, 0.64],
    ),
    MetricItem(
      id: 'uptime',
      title: 'SYSTEM UPTIME',
      value: '99.98%',
      change: '+0.02%',
      isPositive: true,
      materialIcon: Icons.cloud_done_rounded,
      cupertinoIcon: CupertinoIcons.cloud_fill,
      trend: [0.98, 0.98, 0.99, 0.99, 0.99, 0.99, 1.0],
    ),
  ];

  static const List<ActivityLogItem> recentActivities = [
    ActivityLogItem(
      id: 'act-1',
      title: 'Automatic Backup Completed',
      subtitle: 'Primary database snapshot saved to cloud bucket',
      timestamp: '2m ago',
      type: ActivityType.success,
    ),
    ActivityLogItem(
      id: 'act-2',
      title: 'High Memory Spike Detected',
      subtitle: 'Node cluster 04 exceeded 85% threshold',
      timestamp: '14m ago',
      type: ActivityType.warning,
    ),
    ActivityLogItem(
      id: 'act-3',
      title: 'API Gateway SSL Renewed',
      subtitle: 'Let\'s Encrypt certificate auto-renewed for 90 days',
      timestamp: '1h ago',
      type: ActivityType.info,
    ),
    ActivityLogItem(
      id: 'act-4',
      title: 'Deployment v2.4.0 Live',
      subtitle: 'Production rollout successful across all 3 regions',
      timestamp: '3h ago',
      type: ActivityType.success,
    ),
  ];
}
