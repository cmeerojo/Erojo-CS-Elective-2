import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  final http.Client _client;

  PokemonService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  static const Map<String, String> _headers = {
    'User-Agent': 'PokedexApp/1.0.0',
    'Accept': 'application/json',
  };

  Future<Pokemon> fetchPokemonDetail(int id) async {
    final uri = Uri.parse('$_baseUrl/$id');

    try {
      final response = await _client.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Pokemon.fromDetailJson(data);
      } else {
        throw Exception(
          'Failed to load Pokémon #$id (status code: ${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error while retrieving Pokémon #$id: $e');
    }
  }

  Future<List<Pokemon>> fetchPokemonList({int limit = 30}) async {
    final futures = List.generate(
      limit,
      (index) => fetchPokemonDetail(index + 1),
    );

    return await Future.wait(futures);
  }
}
