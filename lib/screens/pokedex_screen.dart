import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokedex_background.dart';
import '../widgets/pokedex_header.dart';
import '../widgets/pokedex_states.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/type_filter_bar.dart';

class PokedexScreen extends StatefulWidget {
  final PokemonService? service;

  const PokedexScreen({super.key, this.service});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  late final PokemonService _pokemonService;
  late Future<List<Pokemon>> _pokemonListFuture;
  String _selectedType = 'all';

  @override
  void initState() {
    super.initState();
    _pokemonService = widget.service ?? PokemonService();
    _loadPokemon();
  }

  void _loadPokemon() {
    setState(() {
      _selectedType = 'all';
      _pokemonListFuture = _pokemonService.fetchPokemonList(limit: 30);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PokedexBackground(
        child: FutureBuilder<List<Pokemon>>(
          future: _pokemonListFuture,
          builder: (context, snapshot) {
            final allPokemon = snapshot.data ?? [];

            final filteredPokemon = _selectedType == 'all'
                ? allPokemon
                : allPokemon
                    .where((p) => p.types.contains(_selectedType.toLowerCase()))
                    .toList();

            return Column(
              children: [
                PokedexHeader(
                  count: filteredPokemon.length,
                  totalAvailable: allPokemon.length,
                ),
                if (snapshot.hasData && allPokemon.isNotEmpty)
                  TypeFilterBar(
                    selectedType: _selectedType,
                    allPokemon: allPokemon,
                    onSelectType: (type) {
                      setState(() {
                        _selectedType = type;
                      });
                    },
                  ),
                Expanded(
                  child: _buildBody(
                    snapshot: snapshot,
                    filteredPokemon: filteredPokemon,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody({
    required AsyncSnapshot<List<Pokemon>> snapshot,
    required List<Pokemon> filteredPokemon,
  }) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const PokedexLoadingWidget();
    }

    if (snapshot.hasError) {
      return PokedexErrorWidget(
        errorMessage: snapshot.error.toString(),
        onRetry: _loadPokemon,
      );
    }

    final allPokemon = snapshot.data ?? [];

    if (allPokemon.isEmpty) {
      return PokedexEmptyWidget(
        onRefresh: _loadPokemon,
      );
    }

    if (filteredPokemon.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.filter_alt_off_rounded,
                size: 48,
                color: Colors.white54,
              ),
              const SizedBox(height: 12),
              Text(
                'No ${_selectedType.toUpperCase()} Pokémon In The First 30',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'None of the first 30 Pokémon match this type filter.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedType = 'all';
                  });
                },
                child: const Text('SHOW ALL POKÉMON'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadPokemon(),
      color: Theme.of(context).primaryColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 900
              ? 4
              : (constraints.maxWidth > 600 ? 3 : 2);

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.82,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: filteredPokemon.length,
            itemBuilder: (context, index) {
              return PokemonCard(pokemon: filteredPokemon[index]);
            },
          );
        },
      ),
    );
  }
}
