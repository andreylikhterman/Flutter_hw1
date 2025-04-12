class BreedModel {
  final String id;
  final String name;
  final String temperament;
  final String origin;
  final String description;

  const BreedModel({
    required this.id,
    required this.name,
    required this.temperament,
    required this.origin,
    required this.description,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) => BreedModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        temperament: json['temperament'] ?? '',
        origin: json['origin'] ?? '',
        description: json['description'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'temperament': temperament,
        'origin': origin,
        'description': description,
      };
}
