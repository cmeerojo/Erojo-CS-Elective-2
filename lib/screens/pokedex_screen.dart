import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokedex_header.dart';
import '../widgets/pokedex_states.dart';
import '../widgets/pokemon_card.dart';

class PokedexScreen extends StatefulWidget {
  final PokemonService? service;

  const PokedexScreen({super.key, this.service});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  late final PokemonService _pokemonService;
  late Future<List<Pokemon>> _pokemonListFuture;

  @override
  void initState() {
    super.initState();
    _pokemonService = widget.service ?? PokemonService();
    _loadPokemon();
  }

  void _loadPokemon() {
    setState(() {
      _pokemonListFuture = _pokemonService.fetchPokemonList(limit: 30);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<List<Pokemon>>(
            future: _pokemonListFuture,
            builder: (context, snapshot) {
              final count = snapshot.hasData ? snapshot.data!.length : 0;
              return PokedexHeader(count: count);
            },
          ),
          Expanded(
            child: FutureBuilder<List<Pokemon>>(
              future: _pokemonListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const PokedexLoadingWidget();
                }

                if (snapshot.hasError) {
                  return PokedexErrorWidget(
                    errorMessage: snapshot.error.toString(),
                    onRetry: _loadPokemon,
                  );
                }

                final pokemonList = snapshot.data ?? [];

                if (pokemonList.isEmpty) {
                  return PokedexEmptyWidget(
                    onRefresh: _loadPokemon,
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
                        padding: const EdgeInsets.all(12),
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.88,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: pokemonList.length,
                        itemBuilder: (context, index) {
                          return PokemonCard(pokemon: pokemonList[index]);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
