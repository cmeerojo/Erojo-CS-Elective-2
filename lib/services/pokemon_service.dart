import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  final http.Client _client;

  PokemonService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<List<Pokemon>> fetchPokemonList({int limit = 30}) async {
    final uri = Uri.parse('$_baseUrl?limit=$limit');

    try {
      final response = await _client.get(
        uri,
        headers: {
          'User-Agent': 'PokedexApp/1.0.0',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] as List<dynamic>? ?? [];

        return results
            .map((item) => Pokemon.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to load Pokémon from PokéAPI (status code: ${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('An unexpected network error occurred: $e');
    }
  }
}
