import 'package:kototinder/data/models/breed.dart';

class CatModel {
  final String id;
  final String imageUrl;
  final BreedModel breed;
  final DateTime? likedAt;

  CatModel({
    required this.id,
    required this.imageUrl,
    required this.breed,
    this.likedAt,
  });

  factory CatModel.fromJson(Map<String, dynamic> json) {
    final breedJson = json['breeds'][0];
    return CatModel(
      id: json['id'] as String,
      imageUrl: json['url'] as String,
      breed: BreedModel.fromJson(breedJson),
    );
  }

  CatModel copyWith({DateTime? likedAt}) => CatModel(
        id: id,
        imageUrl: imageUrl,
        breed: breed,
        likedAt: likedAt ?? this.likedAt,
      );
}
