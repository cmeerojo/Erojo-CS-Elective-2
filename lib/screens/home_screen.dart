import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/car.dart';

// HomeScreen displays the product catalog in a grid view.
// It is a StatelessWidget because it doesn't hold any mutable internal state; 
// it receives the onToggleTheme callback to delegate theme toggling upwards to ShopApp.
class HomeScreen extends StatelessWidget {
  // Callback passed from parent (ShopApp) to switch between Light and Dark mode
  final VoidCallback onToggleTheme;

  const HomeScreen({
    Key? key,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Standard Material App Bar displayed at the top of the Home screen
      appBar: AppBar(
        title: const Text('JDM Showroom'),
        actions: [
          // Shopping cart action button navigating to the Cart screen via Navigation 2.0
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              context.push('/cart');
            },
          ),
          // Theme toggle action button switching between Light and Dark modes
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      
      // LayoutBuilder inspects the parent constraints (screen width) to implement Responsive Design
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Dynamic grid calculation: 
          // If screen width is under 600px (mobile phone), show 2 columns.
          // If screen width is 600px or larger (tablet/desktop), show 3 columns.
          int crossAxisCount = constraints.maxWidth < 600 ? 2 : 3;

          // GridView.builder lazily builds product cards as they scroll into view for optimal performance
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // Dynamically computed column count
              childAspectRatio: 0.75,         // Width-to-height ratio for card dimensions
              crossAxisSpacing: 16,           // Horizontal spacing between grid cards
              mainAxisSpacing: 16,            // Vertical spacing between grid cards
            ),
            itemCount: dummyCars.length,
            itemBuilder: (context, index) {
              final car = dummyCars[index];
              // Renders an individual car card widget for each item in the dataset
              return CarCard(car: car);
            },
          );
        },
      ),
    );
  }
}

// CarCard is a StatelessWidget responsible for presenting a single JDM car card item in the grid.
// Statelessness is ideal here because the card's display data (Image, Name, Price) is static.
class CarCard extends StatelessWidget {
  final Car car;

  const CarCard({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,                           // Subtle shadow effect around the card
      clipBehavior: Clip.antiAlias,           // Clips child content (image) to match rounded borders
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Smooth 12px rounded corners
      ),
      child: InkWell(
        // Handles touch tap events to navigate to the product detail page via go_router
        onTap: () {
          context.push('/car/${car.id}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top section: Car image loaded dynamically from Unsplash web URL
            Expanded(
              child: Image.network(
                car.imageUrl,
                fit: BoxFit.cover, // Scales image to fill container while maintaining aspect ratio
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.error)),
              ),
            ),
            // Bottom section: Car details (Name and Price)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle Name (truncated with ellipsis if too long)
                  Text(
                    car.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Vehicle Price (styled using primary theme color)
                  Text(
                    '\$${car.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
