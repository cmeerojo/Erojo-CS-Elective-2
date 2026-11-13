import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/jdm_riverpod.dart';
import '../widgets/jdm_car_card.dart';

class JdmShowroomScreen extends ConsumerStatefulWidget {
  final bool supabaseConfigured;

  const JdmShowroomScreen({super.key, required this.supabaseConfigured});

  @override
  ConsumerState<JdmShowroomScreen> createState() => _JdmShowroomScreenState();
}

class _JdmShowroomScreenState extends ConsumerState<JdmShowroomScreen> {
  late RangeValues _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedRange = const RangeValues(jdmMinPrice, jdmMaxPrice);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jdmControllerProvider.notifier).fetchPage(page: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jdmControllerProvider);
    final controller = ref.read(jdmControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('JDM Showroom'),
        actions: [
          if (widget.supabaseConfigured) const _GitHubAuthButton(),
          IconButton(
            onPressed: () => controller.fetchPage(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh showroom',
          ),
        ],
      ),
      body: Column(
        children: [
          _PriceFilter(
            range: _selectedRange,
            onChanged: (range) => setState(() => _selectedRange = range),
            onChangeEnd: controller.setPriceRange,
          ),
          Expanded(child: _buildCars(state, controller)),
          _PaginationBar(
            page: state.page,
            hasNextPage: state.hasNextPage,
            isLoading: state.status == JdmLoadStatus.loading,
            onPrevious: () => controller.fetchPage(page: state.page - 1),
            onNext: () => controller.fetchPage(page: state.page + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildCars(JdmState state, JdmController controller) {
    if (state.status == JdmLoadStatus.loading && state.cars.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == JdmLoadStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48),
              const SizedBox(height: 12),
              const Text(
                'The showroom could not load its cars.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 180),
                child: SingleChildScrollView(
                  child: Text(
                    state.errorMessage ?? 'Check your Supabase configuration.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => controller.fetchPage(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (state.cars.isEmpty) {
      return const Center(child: Text('No JDM cars match this price range.'));
    }

    return Stack(
      children: [
        GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisExtent: 280,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: state.cars.length,
          itemBuilder: (_, index) => JdmCarCard(car: state.cars[index]),
        ),
        if (state.status == JdmLoadStatus.loading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }
}

class _GitHubAuthButton extends StatelessWidget {
  const _GitHubAuthButton();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session =
            snapshot.data?.session ??
            Supabase.instance.client.auth.currentSession;
        if (session == null) {
          return TextButton.icon(
            onPressed: () async {
              try {
                await Supabase.instance.client.auth.signInWithOAuth(
                  OAuthProvider.github,
                );
              } on AuthException catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('GitHub sign-in failed: ${error.message}'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.login),
            label: const Text('Sign in using GitHub'),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          );
        }

        return PopupMenuButton<String>(
          onSelected: (value) async {
            if (value != 'sign_out') return;
            try {
              await Supabase.instance.client.auth.signOut();
            } on AuthException catch (error) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sign-out failed: ${error.message}')),
              );
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'sign_out', child: Text('Sign out')),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                session.user.email ?? 'Signed in',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PriceFilter extends StatelessWidget {
  final RangeValues range;
  final ValueChanged<RangeValues> onChanged;
  final ValueChanged<RangeValues> onChangeEnd;

  const _PriceFilter({
    required this.range,
    required this.onChanged,
    required this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price range: ₱${range.start.toStringAsFixed(0)} - '
              '₱${range.end.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            RangeSlider(
              min: jdmMinPrice,
              max: jdmMaxPrice,
              divisions: 100,
              values: range,
              labels: RangeLabels(
                '₱${range.start.toStringAsFixed(0)}',
                '₱${range.end.toStringAsFixed(0)}',
              ),
              onChanged: onChanged,
              onChangeEnd: onChangeEnd,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  final int page;
  final bool hasNextPage;
  final bool isLoading;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _PaginationBar({
    required this.page,
    required this.hasNextPage,
    required this.isLoading,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: page > 0 && !isLoading ? onPrevious : null,
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Previous page',
            ),
            Text('Page ${page + 1}'),
            IconButton(
              onPressed: hasNextPage && !isLoading ? onNext : null,
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Next page',
            ),
          ],
        ),
      ),
    );
  }
}
