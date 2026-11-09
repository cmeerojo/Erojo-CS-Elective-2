import 'package:flutter/material.dart';
import '../models/jdm_car.dart';

class JdmCarCard extends StatelessWidget {
  final JdmCar car;

  const JdmCarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: car.imageUrl == null || car.imageUrl!.isEmpty
                    ? const Icon(Icons.directions_car, size: 72)
                    : Image.network(
                        car.imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.directions_car, size: 72),
                      ),
              ),
            ),
            Text(
              car.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text('${car.transmission} • ${car.mileage} km'),
            const SizedBox(height: 4),
            Text(
              '₱${car.price.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
