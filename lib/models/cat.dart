import 'package:kototinder/models/breed.dart';

class Cat {
  Cat({required this.id, required this.imageUrl, required this.breed});

  factory Cat.fromJson(Map<String, dynamic> json) {
    final breedJson = json['breeds'][0];
    return Cat(
      id: json['id'] as String,
      imageUrl: json['url'] as String,
      breed: Breed.fromJson(breedJson),
    );
  }

  final String id;
  final String imageUrl;
  final Breed breed;
}
