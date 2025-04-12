import 'package:equatable/equatable.dart';
import 'package:kototinder/domain/entities/breed.dart';

class Cat extends Equatable {
  final String id;
  final String imageUrl;
  final Breed breed;
  final DateTime? likedAt;

  const Cat({
    required this.id,
    required this.imageUrl,
    required this.breed,
    this.likedAt,
  });

  Cat copyWith({DateTime? likedAt}) => Cat(
        id: id,
        imageUrl: imageUrl,
        breed: breed,
        likedAt: likedAt,
      );

  @override
  List<Object?> get props => [id, imageUrl, breed, likedAt];
}
