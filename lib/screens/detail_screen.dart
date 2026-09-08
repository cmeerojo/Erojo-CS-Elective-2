import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/car.dart';
import '../providers/cart_provider.dart';

// DetailScreen presents in-depth vehicle information (Image, Title, Price, Description).
// Receives `carId` passed as a dynamic parameter via Navigation 2.0 (go_router).
class DetailScreen extends StatelessWidget {
  final String carId; // Unique car ID retrieved from route parameters

  const DetailScreen({Key? key, required this.carId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Looks up the specific Car object matching carId from the dummyCars dataset.
    // Includes a fallback to the first car if an invalid ID is somehow provided.
    final car = dummyCars.firstWhere(
      (c) => c.id == carId,
      orElse: () => dummyCars.first,
    );

    return Scaffold(
      // Top Navigation bar displaying car name as screen title
      appBar: AppBar(
        title: Text(car.name),
      ),
      // SingleChildScrollView allows the page to scroll on smaller screens or landscape mode
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top hero section displaying vehicle image
            Hero(
              tag: 'car_img_${car.id}', // Hero animation tag matching home grid card
              child: Image.network(
                car.imageUrl,
                height: 300,
                fit: BoxFit.cover, // Ensures image fills width while preserving aspect ratio
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox(height: 300, child: Center(child: Icon(Icons.error))),
              ),
            ),
            
            // Content section containing title, price, description, and action button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row containing Car Name and Price side-by-side
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Car Name (takes remaining available width)
                      Expanded(
                        child: Text(
                          car.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      // Car Price (highlighted with primary color)
                      Text(
                        '\$${car.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Description Heading
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  
                  // Detailed vehicle text description
                  Text(
                    car.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),
                  
                  // Full-width "Add to Cart" elevated button container
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Adds car to CartProvider without rebuilding DetailScreen (listen: false)
                        Provider.of<CartProvider>(context, listen: false).addItem(car);
                        
                        // Displays confirmation Snackbar with direct "VIEW CART" action
                        final messenger = ScaffoldMessenger.of(context);
                        messenger.clearSnackBars();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('${car.name} added to cart!'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'VIEW CART',
                              onPressed: () {
                                context.push('/cart'); // Opens the cart while preserving back navigation
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 18),
                      ),
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
