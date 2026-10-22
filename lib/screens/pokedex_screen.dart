import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pokemon.dart';
import '../providers/pokemon_riverpod.dart';
import '../widgets/pokedex_background.dart';
import '../widgets/pokedex_header.dart';
import '../widgets/pokedex_states.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/type_filter_bar.dart';
import 'pokemon_detail_screen.dart';

class PokedexScreen extends ConsumerStatefulWidget {
  const PokedexScreen({super.key});

  @override
  ConsumerState<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends ConsumerState<PokedexScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(pokemonControllerProvider).status ==
          PokemonLoadStatus.initial) {
        ref.read(pokemonControllerProvider.notifier).fetch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pokemonControllerProvider);
    final controller = ref.read(pokemonControllerProvider.notifier);

    return Scaffold(
      body: PokedexBackground(
        child: Column(
          children: [
            PokedexHeader(
              count: state.filteredPokemon.length,
              totalAvailable: state.pokemon.length,
              favoriteCount: state.favoritePokemon.length,
              onRefresh: controller.fetch,
            ),
            if (state.status == PokemonLoadStatus.success &&
                state.pokemon.isNotEmpty)
              TypeFilterBar(
                selectedType: state.selectedType,
                allPokemon: state.pokemon,
                onSelectType: controller.selectType,
              ),
            _FavoritesPanel(
              favorites: state.favoritePokemon,
              nicknames: state.nicknames,
              onToggleFavorite: controller.toggleFavorite,
              onOpen: (pokemon) => _openDetail(pokemon),
            ),
            Expanded(child: _buildBody(state)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(PokemonState state) {
    final controller = ref.read(pokemonControllerProvider.notifier);
    if (state.status == PokemonLoadStatus.loading) {
      return const PokedexLoadingWidget();
    }
    if (state.status == PokemonLoadStatus.error) {
      return PokedexErrorWidget(
        errorMessage: state.errorMessage ?? 'Unable to load Pokémon.',
        onRetry: controller.fetch,
      );
    }
    if (state.pokemon.isEmpty) {
      return PokedexEmptyWidget(onRefresh: controller.fetch);
    }
    if (state.filteredPokemon.isEmpty) {
      return Center(
        child: ElevatedButton(
          onPressed: () => controller.selectType('all'),
          child: const Text('SHOW ALL POKÉMON'),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetch,
      color: Theme.of(context).primaryColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth > 900
              ? 4
              : (constraints.maxWidth > 600 ? 3 : 2);
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: 0.78,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: state.filteredPokemon.length,
            itemBuilder: (context, index) {
              final pokemon = state.filteredPokemon[index];
              return PokemonCard(
                pokemon: pokemon,
                nickname: state.nicknameFor(pokemon),
                isFavorite: state.favoriteIds.contains(pokemon.id),
                onToggleFavorite: () => controller.toggleFavorite(pokemon),
                onEditNickname: () => _editNickname(pokemon),
                onTap: () => _openDetail(pokemon),
              );
            },
          );
        },
      ),
    );
  }

  void _openDetail(Pokemon pokemon) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PokemonDetailScreen(pokemon: pokemon)),
    );
  }

  Future<void> _editNickname(Pokemon pokemon) async {
    final controller = TextEditingController(
      text: ref.read(pokemonControllerProvider).nicknameFor(pokemon) ?? '',
    );
    final nickname = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nickname for ${pokemon.capitalizedName}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 20,
          decoration: const InputDecoration(labelText: 'Custom nickname'),
        ),
        actions: [
          if (controller.text.isNotEmpty)
            TextButton(
              onPressed: () => Navigator.pop(context, ''),
              child: const Text('REMOVE'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (nickname != null && mounted) {
      ref
          .read(pokemonControllerProvider.notifier)
          .setNickname(pokemon, nickname);
    }
  }
}

class _FavoritesPanel extends StatefulWidget {
  final List<Pokemon> favorites;
  final Map<int, String> nicknames;
  final ValueChanged<Pokemon> onToggleFavorite;
  final ValueChanged<Pokemon> onOpen;

  const _FavoritesPanel({
    required this.favorites,
    required this.nicknames,
    required this.onToggleFavorite,
    required this.onOpen,
  });

  @override
  State<_FavoritesPanel> createState() => _FavoritesPanelState();
}

class _FavoritesPanelState extends State<_FavoritesPanel> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          textColor: Colors.white,
          iconColor: Colors.white,
          title: Text('FAVORITES (${widget.favorites.length})'),
          leading: const Icon(Icons.favorite),
          trailing: Icon(expanded ? Icons.expand_less : Icons.expand_more),
          onTap: () => setState(() => expanded = !expanded),
        ),
        if (expanded)
          Container(
            constraints: const BoxConstraints(maxHeight: 130),
            color: Colors.black12,
            child: widget.favorites.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No Pokémon have been favorited yet.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: widget.favorites
                        .map(
                          (pokemon) => Material(
                            color: Colors.transparent,
                            child: ListTile(
                              dense: true,
                              onTap: () => widget.onOpen(pokemon),
                              leading: Image.network(
                                pokemon.imageUrl,
                                width: 38,
                                errorBuilder: (_, _, _) =>
                                    const Icon(Icons.catching_pokemon),
                              ),
                              title: Text(
                                widget.nicknames[pokemon.id] ??
                                    pokemon.capitalizedName,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                pokemon.capitalizedName,
                                style: const TextStyle(color: Colors.white60),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () =>
                                    widget.onToggleFavorite(pokemon),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
      ],
    );
  }
}
