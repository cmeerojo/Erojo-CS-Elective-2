import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/car.dart';

// HomeScreen displays the product catalog in a grid view.
// It is a StatelessWidget because it doesn't hold any mutable internal state; 
// it receives the onToggleTheme callback to delegate theme toggling upwards to ShopApp.
class HomeScreen extends StatefulWidget {
  // Callback passed from parent (ShopApp) to switch between Light and Dark mode
  final VoidCallback onToggleTheme;

  const HomeScreen({
    Key? key,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _allBrands = 'All brands';
  String _selectedBrand = _allBrands;

  List<String> get _brands {
    final brands = dummyCars.map((car) => car.brand).toSet().toList()..sort();
    return [_allBrands, ...brands];
  }

  List<Car> get _filteredCars => _selectedBrand == _allBrands
      ? dummyCars
      : dummyCars.where((car) => car.brand == _selectedBrand).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Standard Material App Bar displayed at the top of the Home screen
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'JDM Showroom',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1.4),
            ),
            Text(
              'Curated icons from Japan',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
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
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: DropdownButtonFormField<String>(
              value: _selectedBrand,
              decoration: const InputDecoration(
                labelText: 'Filter by brand',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: _brands
                  .map(
                    (brand) => DropdownMenuItem<String>(
                      value: brand,
                      child: Text(brand),
                    ),
                  )
                  .toList(),
              onChanged: (brand) {
                if (brand != null) {
                  setState(() => _selectedBrand = brand);
                }
              },
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth < 600 ? 2 : 3;
                final cars = _filteredCars;

                if (cars.isEmpty) {
                  return const Center(child: Text('No cars found'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: cars.length,
                  itemBuilder: (context, index) => CarCard(car: cars[index]),
                );
              },
            ),
          ),
        ],
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
      elevation: 2,
      clipBehavior: Clip.antiAlias,           // Clips child content (image) to match rounded borders
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Smooth rounded corners
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
