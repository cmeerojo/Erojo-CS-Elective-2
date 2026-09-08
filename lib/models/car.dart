// Data model class representing an individual JDM Car product in the e-commerce store.
class Car {
  // Unique identifier for the car item (used for routing and cart lookups)
  final String id;

  // Manufacturer brand used by the catalog filter
  final String brand;
  
  // Display name of the car (e.g., "Nissan Skyline GT-R R34")
  final String name;
  
  // Price of the car in US Dollars
  final double price;
  
  // Direct web URL to the car's image hosted on Unsplash
  final String imageUrl;
  
  // Brief description of the vehicle's history, specs, and features
  final String description;

  // Constant constructor requiring all fields to instantiate a Car object
  const Car({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });
}

// Mock dataset containing 8 JDM cars for display in the shop catalog grid.
const List<Car> dummyCars = [
  Car(
    id: '1',
    brand: 'Nissan',
    name: 'Nissan Skyline GT-R R34',
    price: 85000.0,
    imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/c/cf/2001_Nissan_Skyline_GT-R_V-Spec_II_R34_%2879241%29.jpg/960px-2001_Nissan_Skyline_GT-R_V-Spec_II_R34_%2879241%29.jpg',
    description: 'The Nissan Skyline GT-R R34 is a legendary Japanese sports car known for its powerful RB26DETT engine and advanced all-wheel-drive system.',
  ),
  Car(
    id: '2',
    brand: 'Toyota',
    name: 'Toyota Supra MK4',
    price: 90000.0,
    imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/b/bc/1996_Toyota_Supra_A80_%28front%29.jpg/960px-1996_Toyota_Supra_A80_%28front%29.jpg',
    description: 'Famous for its indestructible 2JZ-GTE engine, the MK4 Supra is a tuning icon capable of immense horsepower numbers.',
  ),
  Car(
    id: '3',
    brand: 'Mazda',
    name: 'Mazda RX-7 FD3S',
    price: 65000.0,
    imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/8/8f/2017-06-10_Jason_Clark_RX-7.JPG/960px-2017-06-10_Jason_Clark_RX-7.JPG',
    description: 'The RX-7 features a unique sequential twin-turbo rotary engine, offering an unmatched driving experience and perfectly balanced chassis.',
  ),
  Car(
    id: '4',
    brand: 'Honda',
    name: 'Honda NSX NA1',
    price: 110000.0,
    imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/7/7c/Honda_E-NA1_NSX_%2822022010314%29.jpg/960px-Honda_E-NA1_NSX_%2822022010314%29.jpg',
    description: 'Developed with input from Ayrton Senna, the original NSX showed the world that a supercar could be reliable and easy to drive daily.',
  ),
  Car(
    id: '5',
    brand: 'Mitsubishi',
    name: 'Mitsubishi Lancer Evo VI',
    price: 55000.0,
    imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/1/10/2001_Mitsubishi_Lancer_Evolution_VI_Tommi_M%C3%A4kinen.jpg/960px-2001_Mitsubishi_Lancer_Evolution_VI_Tommi_M%C3%A4kinen.jpg',
    description: 'A rally legend for the streets. The Tommi Mäkinen Edition Evo VI is widely regarded as one of the best Lancer Evolutions ever made.',
  ),
  Car(
    id: '6',
    brand: 'Subaru',
    name: 'Subaru Impreza 22B STi',
    price: 150000.0,
    imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/a/a4/1998_Subaru_Impreza_22B_STi_%2810389%29.jpg/960px-1998_Subaru_Impreza_22B_STi_%2810389%29.jpg',
    description: 'The ultimate classic Subaru. Built to celebrate their 3rd consecutive WRC title and 40th anniversary.',
  ),
  Car(
    id: '7',
    brand: 'Honda',
    name: 'Honda S2000 AP1',
    price: 35000.0,
    imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/2/23/Honda_S2000_004.jpg/960px-Honda_S2000_004.jpg',
    description: 'A pure, driver-focused roadster with a legendary F20C naturally aspirated engine that revs to 9,000 RPM.',
  ),
  Car(
    id: '8',
    brand: 'Nissan',
    name: 'Nissan Silvia S15',
    price: 45000.0,
    imageUrl: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/b/b3/2001_Nissan_Silvia_S15.jpg/960px-2001_Nissan_Silvia_S15.jpg',
    description: 'The definitive drift car. The S15 generation brought refined styling and the potent SR20DET engine.',
  ),
];
