class JdmCar {
  final int id;
  final String make;
  final String model;
  final int year;
  final double price;
  final int mileage;
  final String transmission;
  final String? imageUrl;
  final String? description;

  const JdmCar({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.price,
    required this.mileage,
    required this.transmission,
    this.imageUrl,
    this.description,
  });

  factory JdmCar.fromJson(Map<String, dynamic> json) {
    return JdmCar(
      id: (json['id'] as num?)?.toInt() ?? 0,
      make: json['make'] as String? ?? 'Unknown make',
      model: json['model'] as String? ?? 'Unknown model',
      year: (json['year'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      mileage: (json['mileage'] as num?)?.toInt() ?? 0,
      transmission: json['transmission'] as String? ?? 'Unknown',
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String?,
    );
  }

  String get title => '$year $make $model';
}
