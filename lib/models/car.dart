class Car {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;

  const Car({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });
}

const List<Car> dummyCars = [
  Car(
    id: '1',
    name: 'Nissan Skyline GT-R R34',
    price: 85000.0,
    imageUrl: 'https://images.unsplash.com/photo-1600713725708-ed80b271d53e?q=80&w=600&auto=format&fit=crop',
    description: 'The Nissan Skyline GT-R R34 is a legendary Japanese sports car known for its powerful RB26DETT engine and advanced all-wheel-drive system.',
  ),
  Car(
    id: '2',
    name: 'Toyota Supra MK4',
    price: 90000.0,
    imageUrl: 'https://images.unsplash.com/photo-1611015690324-4f056d68b3dc?auto=format&fit=crop&w=600&q=80',
    description: 'Famous for its indestructible 2JZ-GTE engine, the MK4 Supra is a tuning icon capable of immense horsepower numbers.',
  ),
  Car(
    id: '3',
    name: 'Mazda RX-7 FD3S',
    price: 65000.0,
    imageUrl: 'https://images.unsplash.com/photo-1596706798020-562a04944d18?auto=format&fit=crop&w=600&q=80',
    description: 'The RX-7 features a unique sequential twin-turbo rotary engine, offering an unmatched driving experience and perfectly balanced chassis.',
  ),
  Car(
    id: '4',
    name: 'Honda NSX NA1',
    price: 110000.0,
    imageUrl: 'https://images.unsplash.com/photo-1615554101490-c040d12e8416?auto=format&fit=crop&w=600&q=80',
    description: 'Developed with input from Ayrton Senna, the original NSX showed the world that a supercar could be reliable and easy to drive daily.',
  ),
  Car(
    id: '5',
    name: 'Mitsubishi Lancer Evo VI',
    price: 55000.0,
    imageUrl: 'https://images.unsplash.com/photo-1533227268428-f9ed0900f9bf?auto=format&fit=crop&w=600&q=80',
    description: 'A rally legend for the streets. The Tommi Mäkinen Edition Evo VI is widely regarded as one of the best Lancer Evolutions ever made.',
  ),
  Car(
    id: '6',
    name: 'Subaru Impreza 22B STi',
    price: 150000.0,
    imageUrl: 'https://images.unsplash.com/photo-1603515092067-1563f6990d0b?auto=format&fit=crop&w=600&q=80',
    description: 'The ultimate classic Subaru. Built to celebrate their 3rd consecutive WRC title and 40th anniversary.',
  ),
  Car(
    id: '7',
    name: 'Honda S2000 AP1',
    price: 35000.0,
    imageUrl: 'https://images.unsplash.com/photo-1623914846743-34e85970c644?auto=format&fit=crop&w=600&q=80',
    description: 'A pure, driver-focused roadster with a legendary F20C naturally aspirated engine that revs to 9,000 RPM.',
  ),
  Car(
    id: '8',
    name: 'Nissan Silvia S15',
    price: 45000.0,
    imageUrl: 'https://images.unsplash.com/photo-1599385627763-7eb6180a221b?auto=format&fit=crop&w=600&q=80',
    description: 'The definitive drift car. The S15 generation brought refined styling and the potent SR20DET engine.',
  ),
];
