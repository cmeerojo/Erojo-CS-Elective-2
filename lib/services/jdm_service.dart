import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/jdm_car.dart';

class JdmPage {
  final List<JdmCar> cars;
  final bool hasNextPage;

  const JdmPage({required this.cars, required this.hasNextPage});
}

class JdmService {
  final SupabaseClient? _configuredClient;

  JdmService({SupabaseClient? client}) : _configuredClient = client;

  SupabaseClient get _client {
    if (_configuredClient != null) return _configuredClient;
    try {
      return Supabase.instance.client;
    } on AssertionError {
      throw StateError(
        'Supabase is not configured. Add SUPABASE_URL and '
        'SUPABASE_ANON_KEY to a .env file, then restart the app.',
      );
    }
  }

  Future<JdmPage> fetchPage({
    required int page,
    required int pageSize,
    required double minPrice,
    required double maxPrice,
  }) async {
    final start = page * pageSize;
    final end = start + pageSize - 1;
    final response = await _client
        .from('jdm_cars')
        .select()
        .gte('price', minPrice)
        .lte('price', maxPrice)
        .order('id')
        .range(start, end);

    final cars = (response as List<dynamic>)
        .map((row) => JdmCar.fromJson(row as Map<String, dynamic>))
        .toList();
    return JdmPage(cars: cars, hasNextPage: cars.length == pageSize);
  }
}
