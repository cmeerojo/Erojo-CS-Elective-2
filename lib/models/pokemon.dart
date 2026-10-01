class Pokemon {
  final int id;
  final String name;
  final String url;
  final String imageUrl;
  final List<String> types;

  const Pokemon({
    required this.id,
    required this.name,
    required this.url,
    required this.imageUrl,
    this.types = const [],
  });

  String get formattedId => '#${id.toString().padLeft(3, '0')}';

  String get capitalizedName {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '';
    final url = json['url'] as String? ?? '';

    final uriSegments = Uri.parse(url).pathSegments.where((s) => s.isNotEmpty).toList();
    final id = uriSegments.isNotEmpty ? int.tryParse(uriSegments.last) ?? 0 : 0;

    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return Pokemon(
      id: id,
      name: name,
      url: url,
      imageUrl: imageUrl,
      types: const [],
    );
  }

  factory Pokemon.fromDetailJson(Map<String, dynamic> json) {
    final id = json['id'] as int? ?? 0;
    final name = json['name'] as String? ?? '';

    final rawTypes = json['types'] as List<dynamic>? ?? [];
    final typesList = rawTypes
        .map((t) => (t['type']?['name'] as String? ?? '').toLowerCase())
        .where((t) => t.isNotEmpty)
        .toList();

    final artwork = json['sprites']?['other']?['official-artwork']?['front_default'] as String?;
    final sprite = json['sprites']?['front_default'] as String?;
    final imageUrl = artwork ??
        sprite ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return Pokemon(
      id: id,
      name: name,
      url: 'https://pokeapi.co/api/v2/pokemon/$id/',
      imageUrl: imageUrl,
      types: typesList,
    );
  }
}
