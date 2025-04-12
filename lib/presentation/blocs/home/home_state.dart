import 'package:equatable/equatable.dart';
import 'package:kototinder/domain/entities/cat.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Cat> cats;
  final int likeCount;

  const HomeLoaded(this.cats, this.likeCount);

  @override
  List<Object?> get props => [cats, likeCount];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
