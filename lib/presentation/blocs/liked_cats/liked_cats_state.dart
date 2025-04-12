import 'package:equatable/equatable.dart';
import 'package:kototinder/domain/entities/cat.dart';

abstract class LikedCatsState extends Equatable {
  const LikedCatsState();

  @override
  List<Object?> get props => [];
}

class LikedCatsInitial extends LikedCatsState {}

class LikedCatsLoaded extends LikedCatsState {
  final List<Cat> likedCats;
  final List<Cat> filteredCats;
  final String selectedBreed;

  const LikedCatsLoaded({
    required this.likedCats,
    required this.filteredCats,
    this.selectedBreed = '',
  });

  @override
  List<Object?> get props => [likedCats, filteredCats, selectedBreed];
}
