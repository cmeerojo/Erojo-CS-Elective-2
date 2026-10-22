import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

final pokemonServiceProvider = Provider<PokemonService>((ref) {
  return PokemonService();
});

enum PokemonLoadStatus { initial, loading, success, error }

class PokemonState {
  final PokemonLoadStatus status;
  final List<Pokemon> pokemon;
  final String? errorMessage;
  final String selectedType;
  final Set<int> favoriteIds;
  final Map<int, String> nicknames;

  const PokemonState({
    this.status = PokemonLoadStatus.initial,
    this.pokemon = const [],
    this.errorMessage,
    this.selectedType = 'all',
    this.favoriteIds = const {},
    this.nicknames = const {},
  });

  List<Pokemon> get filteredPokemon {
    if (selectedType == 'all') return pokemon;
    return pokemon
        .where((entry) => entry.types.contains(selectedType))
        .toList();
  }

  List<Pokemon> get favoritePokemon =>
      pokemon.where((entry) => favoriteIds.contains(entry.id)).toList();

  String? nicknameFor(Pokemon entry) => nicknames[entry.id];

  PokemonState copyWith({
    PokemonLoadStatus? status,
    List<Pokemon>? pokemon,
    String? errorMessage,
    bool clearError = false,
    String? selectedType,
    Set<int>? favoriteIds,
    Map<int, String>? nicknames,
  }) {
    return PokemonState(
      status: status ?? this.status,
      pokemon: pokemon ?? this.pokemon,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedType: selectedType ?? this.selectedType,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      nicknames: nicknames ?? this.nicknames,
    );
  }
}

final pokemonControllerProvider =
    NotifierProvider<PokemonController, PokemonState>(PokemonController.new);

class PokemonController extends Notifier<PokemonState> {
  PokemonService get _service => ref.read(pokemonServiceProvider);

  @override
  PokemonState build() => const PokemonState();

  Future<void> fetch({int limit = 30}) async {
    state = state.copyWith(status: PokemonLoadStatus.loading, clearError: true);
    try {
      final pokemon = await _service.fetchPokemonList(limit: limit);
      state = state.copyWith(
        status: PokemonLoadStatus.success,
        pokemon: pokemon,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        status: PokemonLoadStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  void selectType(String type) {
    state = state.copyWith(selectedType: type.toLowerCase());
  }

  void toggleFavorite(Pokemon pokemon) {
    final favorites = {...state.favoriteIds};
    if (!favorites.add(pokemon.id)) favorites.remove(pokemon.id);
    state = state.copyWith(favoriteIds: favorites);
  }

  void setNickname(Pokemon pokemon, String nickname) {
    final updated = {...state.nicknames};
    final trimmed = nickname.trim();
    if (trimmed.isEmpty) {
      updated.remove(pokemon.id);
    } else {
      updated[pokemon.id] = trimmed;
    }
    state = state.copyWith(nicknames: updated);
  }

  void removeNickname(Pokemon pokemon) {
    final updated = {...state.nicknames}..remove(pokemon.id);
    state = state.copyWith(nicknames: updated);
  }
}
