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

void main() {
  test('Pokemon model correctly parses JSON and formats fields', () {
    final json = {
      'name': 'bulbasaur',
      'url': 'https://pokeapi.co/api/v2/pokemon/1/',
    };

    final pokemon = Pokemon.fromJson(json);

    expect(pokemon.id, 1);
    expect(pokemon.name, 'bulbasaur');
    expect(pokemon.capitalizedName, 'Bulbasaur');
    expect(pokemon.formattedId, '#001');
    expect(
      pokemon.imageUrl,
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
    );
  });

  testWidgets('PokemonCard renders formatted ID and name', (WidgetTester tester) async {
    const pokemon = Pokemon(
      id: 25,
      name: 'pikachu',
      url: 'https://pokeapi.co/api/v2/pokemon/25/',
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
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
  });

  testWidgets('PokedexApp smoke test and header verification', (WidgetTester tester) async {
    await tester.pumpWidget(const PokedexApp());

    expect(find.text('POKÉDEX'), findsOneWidget);
    expect(find.textContaining('Scanning Pokédex Database'), findsOneWidget);
  });

  test('PokemonService correctly parses 30 Pokemon from API response', () async {
    final mockResults = List.generate(
      30,
      (i) => {
        'name': 'pokemon-${i + 1}',
        'url': 'https://pokeapi.co/api/v2/pokemon/${i + 1}/',
      },
    );

    final mockClient = MockClient((request) async {
      expect(request.url.queryParameters['limit'], '30');
      return http.Response(
        jsonEncode({'results': mockResults}),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final service = PokemonService(client: mockClient);
    final list = await service.fetchPokemonList(limit: 30);

    expect(list.length, 30);
    expect(list.first.id, 1);
    expect(list.first.name, 'pokemon-1');
    expect(list.last.id, 30);
    expect(list.last.name, 'pokemon-30');
  });

  test('PokemonService throws Exception on server error', () async {
    final mockClient = MockClient((request) async {
      return http.Response('Internal Server Error', 500);
    });

    final service = PokemonService(client: mockClient);
    expect(
      () => service.fetchPokemonList(limit: 30),
      throwsA(isA<Exception>()),
    );
  });

  testWidgets('PokedexScreen displays error state and retry on failure', (WidgetTester tester) async {
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

  testWidgets('PokedexScreen displays empty state when 0 results returned', (WidgetTester tester) async {
    final mockClient = MockClient((request) async {
      return http.Response(
        jsonEncode({'results': []}),
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

    expect(find.byType(PokedexEmptyWidget), findsOneWidget);
    expect(find.text('REFRESH POKÉDEX'), findsOneWidget);
  });

  testWidgets('PokedexScreen displays grid of Pokemon cards on success', (WidgetTester tester) async {
    final mockResults = List.generate(
      30,
      (i) => {
        'name': 'pokemon-${i + 1}',
        'url': 'https://pokeapi.co/api/v2/pokemon/${i + 1}/',
      },
    );

    final mockClient = MockClient((request) async {
      return http.Response(
        jsonEncode({'results': mockResults}),
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
    expect(find.text('Pokemon-1'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);
    expect(find.text('FIRE RED • 30 POKÉMON'), findsOneWidget);
  });
}
