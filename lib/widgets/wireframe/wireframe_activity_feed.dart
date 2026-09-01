import 'package:flutter/material.dart';
import '../../models/dashboard_data.dart';
import '../adaptive/adaptive_widgets.dart';

class WireframeActivityFeed extends StatelessWidget {
  const WireframeActivityFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveWireframeCard(
      tagLabel: 'FEED: LIVE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, size: 18, color: Color(0xFFF59E0B)),
                  SizedBox(width: 6),
                  Text(
                    'ACTIVITY LOG',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(radius: 3, backgroundColor: Color(0xFF10B981)),
                    SizedBox(width: 4),
                    Text(
                      'STREAMING',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF059669),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: DashboardData.recentActivities.length,
            separatorBuilder: (context, index) => const Divider(
              height: 16,
              thickness: 0.8,
              color: Color(0xFFF1F5F9),
            ),
            itemBuilder: (context, index) {
              final item = DashboardData.recentActivities[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: item.type.color.withAlpha(25),
                      shape: BoxShape.circle,
                      border: Border.all(color: item.type.color.withAlpha(80)),
                    ),
                    child: AdaptiveIcon(
                      materialIcon: item.type.materialIcon,
                      cupertinoIcon: item.type.cupertinoIcon,
                      size: 14,
                      color: item.type.color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.timestamp,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF94A3B8),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
