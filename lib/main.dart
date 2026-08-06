import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dialing Screen',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF22B7E6),
          brightness: Brightness.light,
        ),
      ),
      home: const CallScreen(),
    );
  }
}

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: 320,
            height: 680,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(34),
              border: Border.all(color: const Color(0xFFE7EBF1), width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Dialing',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D1D1F),
                    ),
                  ),
                  const SizedBox(height: 34),
                  const _RingAvatar(),
                  const SizedBox(height: 38),
                  const Text(
                    'Pearl Luna',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF17181C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '+ 476-229-9449',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Container(height: 1, color: const Color(0xFFE6E7EC)),
                  const Spacer(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ActionItem(icon: Icons.mic_none, label: 'Mute'),
                      _ActionItem(icon: Icons.bluetooth, label: 'Bluetooth'),
                      _ActionItem(icon: Icons.pause_circle_outline, label: 'Hold'),
                    ],
                  ),
                  const SizedBox(height: 38),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ActionItem(icon: Icons.grid_view_rounded, label: ''),
                      _CallButton(),
                      _ActionItem(icon: Icons.volume_up_outlined, label: ''),
                    ],
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingAvatar extends StatelessWidget {
  const _RingAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      height: 168,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [
            Color(0xFFF1FBFD),
            Color(0xFFC6F0FA),
            Color(0xFF67D5F0),
          ],
          stops: [0.36, 0.72, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 128,
          height: 128,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF7FDDF1),
          ),
          child: Center(
            child: Container(
              width: 112,
              height: 112,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Center(
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: Color(0xFFBFE7F0),
                  child: Icon(Icons.person, size: 58, color: Color(0xFF1080A8)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Icon(icon, size: 28, color: const Color(0xFF8B9099)),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF666A73),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  const _CallButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF18B8EA),
      ),
      child: const Icon(Icons.call, color: Colors.white, size: 28),
    );
  }
}
