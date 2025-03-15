class Breed {
  const Breed({
    required this.id,
    required this.name,
    required this.temperament,
    required this.origin,
    required this.description,
  });

  factory Breed.fromJson(Map<String, dynamic> json) => Breed(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        temperament: json['temperament'] ?? '',
        origin: json['origin'] ?? '',
        description: json['description'] ?? '',
      );

  final String id;
  final String name;
  final String temperament;
  final String origin;
  final String description;
}
