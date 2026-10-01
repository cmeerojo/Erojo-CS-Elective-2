import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/pokemon.dart';
import 'package:flutter_application_1/screens/pokedex_screen.dart';
import 'package:flutter_application_1/services/pokemon_service.dart';
import 'package:flutter_application_1/widgets/pokedex_states.dart';
import 'package:flutter_application_1/widgets/pokemon_card.dart';
import 'package:flutter_application_1/widgets/type_filter_bar.dart';

void main() {
  test('Pokemon model correctly parses detail JSON including types', () {
    final detailJson = {
      'id': 6,
      'name': 'charizard',
      'types': [
        {
          'slot': 1,
          'type': {'name': 'fire'}
        },
        {
          'slot': 2,
          'type': {'name': 'flying'}
        }
      ],
      'sprites': {
        'other': {
          'official-artwork': {
            'front_default': 'https://example.com/charizard.png'
          }
        }
      }
    };

    final pokemon = Pokemon.fromDetailJson(detailJson);

    expect(pokemon.id, 6);
    expect(pokemon.name, 'charizard');
    expect(pokemon.capitalizedName, 'Charizard');
    expect(pokemon.formattedId, '#006');
    expect(pokemon.types, ['fire', 'flying']);
    expect(pokemon.imageUrl, 'https://example.com/charizard.png');
  });

  testWidgets('PokemonCard renders formatted ID, name, and type badges', (WidgetTester tester) async {
    const pokemon = Pokemon(
      id: 25,
      name: 'pikachu',
      url: 'https://pokeapi.co/api/v2/pokemon/25/',
      imageUrl: 'https://example.com/pikachu.png',
      types: ['electric'],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PokemonCard(pokemon: pokemon),
        ),
      ),
    );

    expect(find.text('#025'), findsOneWidget);
    expect(find.text('Pikachu'), findsOneWidget);
    expect(find.text('ELECTRIC'), findsOneWidget);
  });

  testWidgets('TypeFilterBar renders options and calls callback on select', (WidgetTester tester) async {
    const list = [
      Pokemon(id: 1, name: 'bulbasaur', url: '', imageUrl: '', types: ['grass', 'poison']),
      Pokemon(id: 4, name: 'charmander', url: '', imageUrl: '', types: ['fire']),
    ];

    String selected = 'all';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TypeFilterBar(
            selectedType: selected,
            allPokemon: list,
            onSelectType: (t) => selected = t,
          ),
        ),
      ),
    );

    expect(find.text('ALL'), findsOneWidget);
    expect(find.text('FIRE'), findsOneWidget);
    expect(find.text('GRASS'), findsOneWidget);
    expect(find.text('POISON'), findsOneWidget);

    await tester.tap(find.text('FIRE'));
    expect(selected, 'fire');
  });

  testWidgets('PokedexApp smoke test and header verification', (WidgetTester tester) async {
    await tester.pumpWidget(const PokedexApp());

    expect(find.text('POKÉDEX'), findsOneWidget);
    expect(find.textContaining('Scanning Pokédex Database'), findsOneWidget);
  });

  test('PokemonService fetchRandomPokemonList fetches 30 unique Pokemon', () async {
    final mockClient = MockClient((request) async {
      final idStr = request.url.pathSegments.last;
      final id = int.tryParse(idStr) ?? 1;
      return http.Response(
        jsonEncode({
          'id': id,
          'name': 'pokemon-$id',
          'types': [
            {
              'slot': 1,
              'type': {'name': id.isEven ? 'water' : 'fire'}
            }
          ],
          'sprites': {
            'other': {
              'official-artwork': {'front_default': 'https://example.com/$id.png'}
            }
          }
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final service = PokemonService(client: mockClient);
    final list = await service.fetchPokemonList(limit: 30);

    expect(list.length, 30);
    expect(list.first.id, 1);
    expect(list.last.id, 30);
  });

  testWidgets('PokedexScreen displays error state on failure', (WidgetTester tester) async {
    final mockClient = MockClient((request) async {
      return http.Response('Error', 500);
    });

    final service = PokemonService(client: mockClient);

    await tester.pumpWidget(
      MaterialApp(
        home: PokedexScreen(service: service),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(PokedexErrorWidget), findsOneWidget);
    expect(find.text('RETRY TRANSMISSION'), findsOneWidget);
  });

  testWidgets('PokedexScreen filters grid when type chip is tapped', (WidgetTester tester) async {
    final mockClient = MockClient((request) async {
      final idStr = request.url.pathSegments.last;
      final id = int.tryParse(idStr) ?? 1;
      final type = id.isEven ? 'water' : 'fire';
      return http.Response(
        jsonEncode({
          'id': id,
          'name': 'pokemon-$id',
          'types': [
            {
              'slot': 1,
              'type': {'name': type}
            }
          ],
          'sprites': {
            'other': {
              'official-artwork': {'front_default': 'https://example.com/$id.png'}
            }
          }
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final service = PokemonService(client: mockClient);

    await tester.pumpWidget(
      MaterialApp(
        home: PokedexScreen(service: service),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(GridView), findsOneWidget);
    final fireFilterChip = find.descendant(
      of: find.byType(TypeFilterBar),
      matching: find.text('FIRE'),
    );
    await tester.tap(fireFilterChip);
    await tester.pump();

    expect(find.textContaining('OF 30'), findsOneWidget);
  });
}
