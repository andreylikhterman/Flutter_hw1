import 'package:equatable/equatable.dart';
import 'package:kototinder/domain/entities/cat.dart';

abstract class LikedCatsEvent extends Equatable {
  const LikedCatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadLikedCats extends LikedCatsEvent {
  final List<Cat> likedCats;

  const LoadLikedCats(this.likedCats);

  @override
  List<Object?> get props => [likedCats];
}

class RemoveLikedCat extends LikedCatsEvent {
  final Cat cat;

  const RemoveLikedCat(this.cat);

  @override
  List<Object?> get props => [cat];
}

class FilterByBreed extends LikedCatsEvent {
  final String breed;

  const FilterByBreed(this.breed);

  @override
  List<Object?> get props => [breed];
}
