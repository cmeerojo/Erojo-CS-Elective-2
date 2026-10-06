import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/pokedex_background.dart';

class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();
    final pokemon = provider.selectedPokemon;

    return Scaffold(
      body: PokedexBackground(
        child: pokemon == null
            ? _buildNoSelection(context)
            : Column(
                children: [
                  _buildHeader(context, pokemon.formattedId),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildArtworkDisplay(
                            pokemon.imageUrl,
                            pokemon.formattedId,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            pokemon.capitalizedName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildNoSelection(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.catching_pokemon, size: 64, color: Colors.white38),
          const SizedBox(height: 16),
          const Text(
            'No Pokémon Selected',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('RETURN TO POKÉDEX'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String formattedId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: AppTheme.fireRedPrimary,
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 6),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              tooltip: 'Back to Pokédex',
              onPressed: () => Navigator.of(context).pop(),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.sensorBlue.withValues(alpha: 0.6),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment(-0.3, -0.3),
                    radius: 0.8,
                    colors: [
                      Colors.white,
                      AppTheme.sensorBlue,
                      Color(0xFF007799),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildIndicatorLed(AppTheme.sensorRed),
            const SizedBox(width: 5),
            _buildIndicatorLed(AppTheme.sensorYellow),
            const SizedBox(width: 5),
            _buildIndicatorLed(AppTheme.sensorGreen),
            const Spacer(),
            Text(
              'ENTRY $formattedId',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtworkDisplay(String imageUrl, String formattedId) {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: const Color(0xFF282A30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.fireRedFlame.withValues(alpha: 0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 12,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.fireRedPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                formattedId,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.fireRedPrimary,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 64,
                    color: Colors.white38,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorLed(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black26, width: 1),
      ),
    );
  }
}
