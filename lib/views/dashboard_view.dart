import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/dashboard_data.dart';
import '../widgets/adaptive/adaptive_widgets.dart';
import '../widgets/wireframe/wireframe_activity_feed.dart';
import '../widgets/wireframe/wireframe_chart.dart';
import '../widgets/wireframe/wireframe_header_banner.dart';
import '../widgets/wireframe/wireframe_metric_card.dart';
import '../widgets/wireframe/wireframe_quick_controls.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isIos = AdaptivePlatformScope.of(context).isCupertino(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileLayout(context, constraints, isIos);
        } else if (constraints.maxWidth < 1024) {
          return _buildTabletLayout(context, constraints, isIos);
        } else {
          return _buildDesktopLayout(context, constraints, isIos);
        }
      },
    );
  }

  // ==========================================
  // 1. MOBILE LAYOUT (< 600px)
  // ==========================================
  Widget _buildMobileLayout(BuildContext context, BoxConstraints constraints, bool isIos) {
    final scrollPhysics = isIos
        ? const BouncingScrollPhysics()
        : const AlwaysScrollableScrollPhysics();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: isIos
            ? CupertinoNavigationBar(
                middle: const Text(
                  'Wireframe Console',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                backgroundColor: CupertinoColors.systemBackground.withAlpha(220),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  child: const Icon(CupertinoIcons.bell, size: 22),
                ),
              )
            : AppBar(
                title: const Text(
                  'Wireframe Console',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                backgroundColor: Colors.white,
                elevation: 0.5,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded),
                    onPressed: () {},
                  ),
                ],
              ),
      ),
      body: SingleChildScrollView(
        physics: scrollPhysics,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WireframeHeaderBanner(
              currentWidth: constraints.maxWidth,
              layoutName: 'MOBILE LAYOUT',
            ),
            // 2x2 Grid for Metric Cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemCount: DashboardData.metrics.length,
              itemBuilder: (context, index) {
                return WireframeMetricCard(metric: DashboardData.metrics[index]);
              },
            ),
            const SizedBox(height: 16),
            const WireframeChartSection(),
            const SizedBox(height: 16),
            const WireframeQuickControls(),
            const SizedBox(height: 16),
            const WireframeActivityFeed(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: isIos
          ? CupertinoTabBar(
              currentIndex: _selectedNavIndex,
              onTap: (index) => setState(() => _selectedNavIndex = index),
              activeColor: const Color(0xFF0284C7),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_grid_2x2_fill),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.chart_bar_square),
                  label: 'Metrics',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.gear),
                  label: 'Controls',
                ),
              ],
            )
          : NavigationBar(
              selectedIndex: _selectedNavIndex,
              onDestinationSelected: (index) => setState(() => _selectedNavIndex = index),
              backgroundColor: Colors.white,
              indicatorColor: const Color(0xFFE0F2FE),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard_rounded, color: Color(0xFF0284C7)),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart_rounded, color: Color(0xFF0284C7)),
                  label: 'Metrics',
                ),
                NavigationDestination(
                  icon: Icon(Icons.tune_outlined),
                  selectedIcon: Icon(Icons.tune_rounded, color: Color(0xFF0284C7)),
                  label: 'Controls',
                ),
              ],
            ),
    );
  }

  // ==========================================
  // 2. TABLET LAYOUT (600px - 1023px)
  // ==========================================
  Widget _buildTabletLayout(BuildContext context, BoxConstraints constraints, bool isIos) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Navigation Rail
          NavigationRail(
            selectedIndex: _selectedNavIndex,
            onDestinationSelected: (index) => setState(() => _selectedNavIndex = index),
            backgroundColor: Colors.white,
            labelType: NavigationRailLabelType.selected,
            indicatorColor: const Color(0xFFE0F2FE),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 20),
              ),
            ),
            destinations: [
              NavigationRailDestination(
                icon: AdaptiveIcon(
                  materialIcon: Icons.dashboard_outlined,
                  cupertinoIcon: CupertinoIcons.square_grid_2x2,
                  color: const Color(0xFF64748B),
                ),
                selectedIcon: AdaptiveIcon(
                  materialIcon: Icons.dashboard_rounded,
                  cupertinoIcon: CupertinoIcons.square_grid_2x2_fill,
                  color: const Color(0xFF0284C7),
                ),
                label: const Text('Overview', style: TextStyle(fontSize: 11)),
              ),
              NavigationRailDestination(
                icon: AdaptiveIcon(
                  materialIcon: Icons.analytics_outlined,
                  cupertinoIcon: CupertinoIcons.chart_bar,
                  color: const Color(0xFF64748B),
                ),
                selectedIcon: AdaptiveIcon(
                  materialIcon: Icons.analytics_rounded,
                  cupertinoIcon: CupertinoIcons.chart_bar_fill,
                  color: const Color(0xFF0284C7),
                ),
                label: const Text('Analytics', style: TextStyle(fontSize: 11)),
              ),
              NavigationRailDestination(
                icon: AdaptiveIcon(
                  materialIcon: Icons.settings_outlined,
                  cupertinoIcon: CupertinoIcons.gear,
                  color: const Color(0xFF64748B),
                ),
                selectedIcon: AdaptiveIcon(
                  materialIcon: Icons.settings_rounded,
                  cupertinoIcon: CupertinoIcons.gear_solid,
                  color: const Color(0xFF0284C7),
                ),
                label: const Text('Settings', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Color(0xFFE2E8F0)),

          // Main Tablet Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WireframeHeaderBanner(
                    currentWidth: constraints.maxWidth,
                    layoutName: 'TABLET LAYOUT (2-COLUMN)',
                  ),
                  // 4 Metrics Grid (2 columns on tablet)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: DashboardData.metrics.length,
                    itemBuilder: (context, index) {
                      return WireframeMetricCard(metric: DashboardData.metrics[index]);
                    },
                  ),
                  const SizedBox(height: 20),
                  // 2-Column Split
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Area: Chart
                      const Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            WireframeChartSection(),
                            SizedBox(height: 16),
                            WireframeQuickControls(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Right Area: Activity Feed & Nodes
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            const WireframeActivityFeed(),
                            const SizedBox(height: 16),
                            _buildServerNodeSummary(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. DESKTOP LAYOUT (>= 1024px)
  // ==========================================
  Widget _buildDesktopLayout(BuildContext context, BoxConstraints constraints, bool isIos) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Expanded Sidebar
          Container(
            width: 240,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.layers_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WIREFRAME OS',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF0F172A),
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              'v2.4.0 (Enterprise)',
                              style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 12),
                _buildSidebarItem(0, 'Dashboard Overview', Icons.dashboard_outlined, CupertinoIcons.square_grid_2x2),
                _buildSidebarItem(1, 'Traffic & Analytics', Icons.analytics_outlined, CupertinoIcons.chart_bar),
                _buildSidebarItem(2, 'Server Clusters', Icons.dns_outlined, CupertinoIcons.square_stack_3d_up),
                _buildSidebarItem(3, 'Security & Access', Icons.shield_outlined, CupertinoIcons.lock_shield),
                _buildSidebarItem(4, 'Environment Config', Icons.tune_outlined, CupertinoIcons.slider_horizontal_3),
                const Spacer(),
                // Bottom Account / Workspace Status
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF0F172A),
                        child: Text('AD', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DevOps Admin',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            Text(
                              'Cluster US-East-1',
                              style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      AdaptiveIcon(
                        materialIcon: Icons.verified_user_rounded,
                        cupertinoIcon: CupertinoIcons.checkmark_shield_fill,
                        size: 16,
                        color: const Color(0xFF10B981),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Center + Right Content Area
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WireframeHeaderBanner(
                      currentWidth: constraints.maxWidth,
                      layoutName: 'DESKTOP LAYOUT (3-PANEL)',
                    ),

                    // 4 KPI Cards in a single row
                    Row(
                      children: DashboardData.metrics.map((metric) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: WireframeMetricCard(metric: metric),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Two-Column Content Layout (7:4 Flex)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Center Area (Flex 7)
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const WireframeChartSection(),
                              const SizedBox(height: 20),
                              _buildClusterNodesTable(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Right Sidebar Area (Flex 4)
                        const Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              WireframeQuickControls(),
                              SizedBox(height: 20),
                              WireframeActivityFeed(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, String title, IconData matIcon, IconData cupertinoIcon) {
    final isSelected = _selectedNavIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => setState(() => _selectedNavIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF1F5F9) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? const Color(0xFFCBD5E1) : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              AdaptiveIcon(
                materialIcon: matIcon,
                cupertinoIcon: cupertinoIcon,
                size: 18,
                color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF64748B),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClusterNodesTable() {
    return AdaptiveWireframeCard(
      tagLabel: 'TABLE: CLUSTER NODES',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACTIVE WORKER NODES',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Region: us-east-1',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 8),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(1.5),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
                children: [
                  _buildTableCell('NODE IDENTIFIER', isHeader: true),
                  _buildTableCell('CPU USAGE', isHeader: true),
                  _buildTableCell('MEMORY ALLOC', isHeader: true),
                  _buildTableCell('STATUS', isHeader: true),
                ],
              ),
              TableRow(
                children: [
                  _buildTableCell('node-cluster-alpha-01'),
                  _buildTableCell('24.2%'),
                  _buildTableCell('4.2 / 16 GB'),
                  _buildTableStatus('ONLINE', const Color(0xFF10B981)),
                ],
              ),
              TableRow(
                children: [
                  _buildTableCell('node-cluster-beta-02'),
                  _buildTableCell('78.6%'),
                  _buildTableCell('12.8 / 16 GB'),
                  _buildTableStatus('BUSY', const Color(0xFFF59E0B)),
                ],
              ),
              TableRow(
                children: [
                  _buildTableCell('node-cluster-gamma-03'),
                  _buildTableCell('12.0%'),
                  _buildTableCell('2.1 / 16 GB'),
                  _buildTableStatus('ONLINE', const Color(0xFF10B981)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? const Color(0xFF475569) : const Color(0xFF0F172A),
          fontFamily: isHeader ? 'sans-serif' : 'monospace',
        ),
      ),
    );
  }

  Widget _buildTableStatus(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerNodeSummary() {
    return AdaptiveWireframeCard(
      tagLabel: 'NODES: SUMMARY',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NODE HEALTH STATUS',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          const Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Text('Healthy Instances', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              Text('3 / 3 (100%)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 1.0,
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation(Color(0xFF10B981)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
