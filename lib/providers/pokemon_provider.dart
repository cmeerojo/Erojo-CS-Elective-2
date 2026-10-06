import 'package:flutter/foundation.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

enum PokemonStatus { initial, loading, success, error }

class PokemonProvider extends ChangeNotifier {
  final PokemonService _service;

  PokemonProvider({PokemonService? service})
      : _service = service ?? PokemonService();

  PokemonStatus _status = PokemonStatus.initial;
  List<Pokemon> _pokemonList = [];
  String? _errorMessage;
  String _selectedType = 'all';
  Pokemon? _selectedPokemon;

  PokemonStatus get status => _status;
  List<Pokemon> get pokemonList => _pokemonList;
  String? get errorMessage => _errorMessage;
  String get selectedType => _selectedType;
  Pokemon? get selectedPokemon => _selectedPokemon;

  bool get isLoading => _status == PokemonStatus.loading;
  bool get isSuccess => _status == PokemonStatus.success;
  bool get isError => _status == PokemonStatus.error;

  List<Pokemon> get filteredPokemon {
    if (_selectedType == 'all') {
      return _pokemonList;
    }
    return _pokemonList
        .where((p) => p.types.contains(_selectedType.toLowerCase()))
        .toList();
  }

  Future<void> fetchPokemon({int limit = 30}) async {
    _status = PokemonStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _pokemonList = await _service.fetchPokemonList(limit: limit);
      _status = PokemonStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _status = PokemonStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshPokemon({int limit = 30}) async {
    await fetchPokemon(limit: limit);
  }

  void selectType(String type) {
    if (_selectedType != type) {
      _selectedType = type;
      notifyListeners();
    }
  }

  void selectPokemon(Pokemon pokemon) {
    _selectedPokemon = pokemon;
    notifyListeners();
  }

  void clearSelectedPokemon() {
    _selectedPokemon = null;
    notifyListeners();
  }
}
