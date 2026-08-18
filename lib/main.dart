import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class Fruit {
  const Fruit({
    required this.name,
    required this.emoji,
    required this.color,
    required this.description,
  });

  final String name;
  final String emoji;
  final Color color;
  final String description;
}

const List<Fruit> fruits = [
  Fruit(
    name: 'Apple',
    emoji: '🍎',
    color: Color(0xFFFF6B6B),
    description: 'Crisp, juicy, and perfect for a healthy snack.',
  ),
  Fruit(
    name: 'Banana',
    emoji: '🍌',
    color: Color(0xFFF7D154),
    description: 'A sweet tropical fruit that grows in clusters.',
  ),
  Fruit(
    name: 'Grape',
    emoji: '🍇',
    color: Color(0xFF9B59B6),
    description: 'Small, sweet berries often eaten fresh or turned into wine.',
  ),
  Fruit(
    name: 'Orange',
    emoji: '🍊',
    color: Color(0xFFFFA726),
    description: 'Bright and citrusy, known for its vitamin C.',
  ),
  Fruit(
    name: 'Strawberry',
    emoji: '🍓',
    color: Color(0xFFE74C3C),
    description: 'A red summer favorite with a sweet, juicy taste.',
  ),
  Fruit(
    name: 'Watermelon',
    emoji: '🍉',
    color: Color(0xFF2ECC71),
    description: 'A refreshing fruit with lots of water and a sweet flavor.',
  ),
  Fruit(
    name: 'Pear',
    emoji: '🍐',
    color: Color(0xFF7CB342),
    description: 'Smooth and subtly sweet, with a mild floral flavor.',
  ),
  Fruit(
    name: 'Peach',
    emoji: '🍑',
    color: Color(0xFFFFB74D),
    description: 'A fuzzy fruit with soft, juicy flesh and a sweet aroma.',
  ),
];

final GoRouter router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return FruitShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const FruitListPage(),
        ),
        GoRoute(
          path: '/fruit/:name',
          builder: (context, state) {
            final fruitName = state.pathParameters['name'] ?? '';
            final selectedFruit = fruits.firstWhere(
              (fruit) => fruit.name.toLowerCase() == fruitName.toLowerCase(),
              orElse: () => fruits.first,
            );
            return FruitDetailPage(fruit: selectedFruit);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Fruit Router Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
    );
  }
}

class FruitShell extends StatelessWidget {
  const FruitShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruit Demo'),
        centerTitle: true,
      ),
      body: child,
    );
  }
}

class FruitListPage extends StatelessWidget {
  const FruitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fruit List',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: fruits.length,
              itemBuilder: (context, index) {
                final fruit = fruits[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: fruit.color.withAlpha(40),
                      child: Text(fruit.emoji, style: const TextStyle(fontSize: 24)),
                    ),
                    title: Text(fruit.name),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      context.go('/fruit/${fruit.name}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FruitDetailPage extends StatelessWidget {
  const FruitDetailPage({super.key, required this.fruit});

  final Fruit fruit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              fruit.emoji,
              style: const TextStyle(fontSize: 120),
            ),
            const SizedBox(height: 20),
            Text(
              fruit.name,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: fruit.color.withAlpha(30),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                fruit.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to fruit list'),
            ),
          ],
        ),
      ),
    );
  }
}
