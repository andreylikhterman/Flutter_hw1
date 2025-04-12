import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:kototinder/domain/entities/cat.dart';
import 'package:kototinder/domain/repositories/cat_repository.dart';
import 'package:kototinder/presentation/blocs/home/home_event.dart';
import 'package:kototinder/presentation/blocs/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CatRepository catRepository;
  int _likeCount = 0;
  final List<Cat> _likedCats = [];
  final List<Cat> _cats = [];

  HomeBloc(this.catRepository) : super(HomeInitial()) {
    on<FetchCat>(_onFetchCat);
    on<LikeCat>(_onLikeCat);
    on<DislikeCat>(_onDislikeCat);
    on<RemoveLikedCatFromHome>(_onRemoveLikedCatFromHome);
  }

  List<Cat> get likedCats => _likedCats;

  Future<void> _onFetchCat(FetchCat event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final newCats = await catRepository.fetchCats(limit: event.count);
      if (newCats.isNotEmpty) {
        _cats.addAll(newCats);
        emit(HomeLoaded(_cats, _likeCount));
      } else {
        emit(const HomeError('No cats found'));
      }
    } catch (e) {
      emit(HomeError('Error: $e'));
    }
  }

  Future<void> _onLikeCat(LikeCat event, Emitter<HomeState> emit) async {
    _likeCount++;
    final catWithDate = event.cat.copyWith(likedAt: DateTime.now());
    _likedCats.add(catWithDate);
    debugPrint(
      'Added cat to likedCats: ${catWithDate.breed.name}, total: ${_likedCats.length}',
    );
    _cats.removeAt(0);
    emit(HomeLoaded(_cats, _likeCount));
  }

  Future<void> _onDislikeCat(DislikeCat event, Emitter<HomeState> emit) async {
    _cats.removeAt(0);
    emit(HomeLoaded(_cats, _likeCount));
  }

  Future<void> _onRemoveLikedCatFromHome(
    RemoveLikedCatFromHome event,
    Emitter<HomeState> emit,
  ) async {
    _likedCats.removeWhere((cat) => cat.id == event.cat.id);
    debugPrint(
      'Removed cat from HomeBloc: ${event.cat.breed.name}, total: ${_likedCats.length}',
    );
    emit(HomeLoaded(_cats, _likeCount));
  }
}
