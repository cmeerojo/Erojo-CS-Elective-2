import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../adaptive/adaptive_widgets.dart';

class WireframeChartSection extends StatefulWidget {
  const WireframeChartSection({super.key});

  @override
  State<WireframeChartSection> createState() => _WireframeChartSectionState();
}

class _WireframeChartSectionState extends State<WireframeChartSection> {
  int _selectedTimeframe = 1; // 0: Daily, 1: Weekly, 2: Monthly

  final List<List<double>> _chartDataSets = [
    [35, 60, 45, 80, 55, 90, 70], // Daily
    [45, 75, 60, 95, 80, 110, 130, 95, 120, 140, 115, 150], // Weekly
    [420, 560, 610, 780, 890, 950], // Monthly
  ];

  final List<List<String>> _labels = [
    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7', 'W8', 'W9', 'W10', 'W11', 'W12'],
    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
  ];

  @override
  Widget build(BuildContext context) {
    final isIos = AdaptivePlatformScope.of(context).isCupertino(context);
    final data = _chartDataSets[_selectedTimeframe];
    final labels = _labels[_selectedTimeframe];
    final maxValue = data.reduce((a, b) => a > b ? a : b);

    return AdaptiveWireframeCard(
      tagLabel: 'CHART: WIREFRAME',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 10,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TRAFFIC & THROUGHPUT',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Real-time requests processed per second',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              // Segmented selector (CupertinoSegmentedControl vs Material segmented buttons)
              _buildSegmentedControl(isIos),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-Axis Labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${maxValue.toInt()}', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontFamily: 'monospace')),
                    Text('${(maxValue * 0.66).toInt()}', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontFamily: 'monospace')),
                    Text('${(maxValue * 0.33).toInt()}', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontFamily: 'monospace')),
                    Text('0', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontFamily: 'monospace')),
                  ],
                ),
                const SizedBox(width: 8),
                // Grid + Bars
                Expanded(
                  child: Stack(
                    children: [
                      // Wireframe Background Grid Lines
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          return Container(
                            height: 1,
                            color: const Color(0xFFE2E8F0),
                          );
                        }),
                      ),
                      // Bars
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(data.length, (index) {
                          final heightFactor = data[index] / maxValue;
                          final isHighest = data[index] == maxValue;

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: FractionallySizedBox(
                                      heightFactor: heightFactor,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isHighest
                                              ? const Color(0xFF0284C7)
                                              : const Color(0xFF94A3B8),
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                          border: Border.all(
                                            color: isHighest
                                                ? const Color(0xFF0369A1)
                                                : const Color(0xFF64748B),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    labels[index],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: isHighest ? FontWeight.bold : FontWeight.normal,
                                      color: isHighest ? const Color(0xFF0284C7) : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Schematic Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(const Color(0xFF0284C7), 'Peak Load'),
              const SizedBox(width: 20),
              _buildLegendItem(const Color(0xFF94A3B8), 'Normal Load'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl(bool isIos) {
    if (isIos) {
      return CupertinoSlidingSegmentedControl<int>(
        groupValue: _selectedTimeframe,
        children: const {
          0: Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Day', style: TextStyle(fontSize: 12))),
          1: Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Week', style: TextStyle(fontSize: 12))),
          2: Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Month', style: TextStyle(fontSize: 12))),
        },
        onValueChanged: (val) {
          if (val != null) setState(() => _selectedTimeframe = val);
        },
      );
    }

    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(value: 0, label: Text('Day', style: TextStyle(fontSize: 11))),
        ButtonSegment(value: 1, label: Text('Week', style: TextStyle(fontSize: 11))),
        ButtonSegment(value: 2, label: Text('Month', style: TextStyle(fontSize: 11))),
      ],
      selected: {_selectedTimeframe},
      style: const ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onSelectionChanged: (newSelection) {
        setState(() => _selectedTimeframe = newSelection.first);
      },
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
