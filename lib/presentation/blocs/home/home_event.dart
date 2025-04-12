import 'package:equatable/equatable.dart';
import 'package:kototinder/domain/entities/cat.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchCat extends HomeEvent {
  final int count;
  const FetchCat({this.count = 1});

  @override
  List<Object?> get props => [count];
}

class LikeCat extends HomeEvent {
  final Cat cat;
  const LikeCat(this.cat);

  @override
  List<Object?> get props => [cat];
}

class DislikeCat extends HomeEvent {}

class RemoveLikedCatFromHome extends HomeEvent {
  final Cat cat;
  const RemoveLikedCatFromHome(this.cat);

  @override
  List<Object?> get props => [cat];
}
