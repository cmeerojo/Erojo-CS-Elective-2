class Pokemon {
  final int id;
  final String name;
  final String url;
  final String imageUrl;

  const Pokemon({
    required this.id,
    required this.name,
    required this.url,
    required this.imageUrl,
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
    );
  }
}
