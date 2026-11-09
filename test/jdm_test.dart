import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/jdm_car.dart';
import 'package:flutter_application_1/widgets/jdm_car_card.dart';

void main() {
  test('JDM car parses showroom data', () {
    final car = JdmCar.fromJson({
      'id': 1,
      'make': 'Nissan',
      'model': 'Skyline GT-R',
      'year': 1999,
      'price': 4500000,
      'mileage': 85000,
      'transmission': 'Manual',
    });

    expect(car.title, '1999 Nissan Skyline GT-R');
    expect(car.price, 4500000);
    expect(car.mileage, 85000);
  });

  testWidgets('JDM car card displays showroom details', (tester) async {
    const car = JdmCar(
      id: 1,
      make: 'Toyota',
      model: 'Supra',
      year: 1998,
      price: 5200000,
      mileage: 70000,
      transmission: 'Manual',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: JdmCarCard(car: car)),
      ),
    );

    expect(find.text('1998 Toyota Supra'), findsOneWidget);
    expect(find.text('Manual • 70000 km'), findsOneWidget);
    expect(find.text('₱5200000'), findsOneWidget);
  });
}
