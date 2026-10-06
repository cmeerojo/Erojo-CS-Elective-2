import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokedex_background.dart';
import '../widgets/pokedex_header.dart';
import '../widgets/pokedex_states.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/type_filter_bar.dart';
import 'pokemon_detail_screen.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PokemonProvider>();
      if (provider.status == PokemonStatus.initial) {
        provider.fetchPokemon(limit: 30);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();
    final allPokemon = provider.pokemonList;
    final filteredPokemon = provider.filteredPokemon;

    return Scaffold(
      body: PokedexBackground(
        child: Column(
          children: [
            PokedexHeader(
              count: filteredPokemon.length,
              totalAvailable: allPokemon.length,
            ),
            if (provider.isSuccess && allPokemon.isNotEmpty)
              TypeFilterBar(
                selectedType: provider.selectedType,
                allPokemon: allPokemon,
                onSelectType: (type) {
                  context.read<PokemonProvider>().selectType(type);
                },
              ),
            Expanded(
              child: _buildBody(
                context: context,
                provider: provider,
                filteredPokemon: filteredPokemon,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required PokemonProvider provider,
    required List<Pokemon> filteredPokemon,
  }) {
    if (provider.isLoading) {
      return const PokedexLoadingWidget();
    }

    if (provider.isError) {
      return PokedexErrorWidget(
        errorMessage: provider.errorMessage ?? 'An error occurred',
        onRetry: () => context.read<PokemonProvider>().fetchPokemon(limit: 30),
      );
    }

    final allPokemon = provider.pokemonList;

    if (allPokemon.isEmpty) {
      return PokedexEmptyWidget(
        onRefresh: () => context.read<PokemonProvider>().fetchPokemon(limit: 30),
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
                'No ${provider.selectedType.toUpperCase()} Pokémon In The First 30',
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
                  context.read<PokemonProvider>().selectType('all');
                },
                child: const Text('SHOW ALL POKÉMON'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<PokemonProvider>().refreshPokemon(limit: 30),
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
              final pokemon = filteredPokemon[index];
              return PokemonCard(
                pokemon: pokemon,
                onTap: () {
                  context.read<PokemonProvider>().selectPokemon(pokemon);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PokemonDetailScreen(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
