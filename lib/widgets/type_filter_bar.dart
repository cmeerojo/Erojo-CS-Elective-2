import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../theme/app_theme.dart';

class TypeFilterBar extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onSelectType;
  final List<Pokemon> allPokemon;

  const TypeFilterBar({
    super.key,
    required this.selectedType,
    required this.onSelectType,
    required this.allPokemon,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, int> typeCounts = {};
    for (final p in allPokemon) {
      for (final t in p.types) {
        typeCounts[t] = (typeCounts[t] ?? 0) + 1;
      }
    }

    final sortedTypes = typeCounts.keys.toList()..sort();
    final filterOptions = ['all', ...sortedTypes];

    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: filterOptions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = filterOptions[index];
          final isSelected = selectedType.toLowerCase() == type.toLowerCase();
          final count = type == 'all' ? allPokemon.length : (typeCounts[type] ?? 0);
          final typeColor = type == 'all'
              ? AppTheme.fireRedFlame
              : AppTheme.getTypeColor(type);

          return InkWell(
            onTap: () => onSelectType(type),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? typeColor : const Color(0xFF282A30),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.white : typeColor.withValues(alpha: 0.6),
                  width: isSelected ? 2 : 1.2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: typeColor.withValues(alpha: 0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black.withValues(alpha: 0.25)
                          : const Color(0xFF1E2024),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
