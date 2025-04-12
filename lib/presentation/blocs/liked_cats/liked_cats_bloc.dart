import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:kototinder/presentation/blocs/liked_cats/liked_cats_event.dart';
import 'package:kototinder/presentation/blocs/liked_cats/liked_cats_state.dart';

class LikedCatsBloc extends Bloc<LikedCatsEvent, LikedCatsState> {
  LikedCatsBloc() : super(LikedCatsInitial()) {
    on<LoadLikedCats>(_onLoadLikedCats);
    on<RemoveLikedCat>(_onRemoveLikedCat);
    on<FilterByBreed>(_onFilterByBreed);
  }

  Future<void> _onLoadLikedCats(
    LoadLikedCats event,
    Emitter<LikedCatsState> emit,
  ) async {
    debugPrint('Loading liked cats: ${event.likedCats.length}');
    emit(
      LikedCatsLoaded(
        likedCats: event.likedCats,
        filteredCats: event.likedCats,
      ),
    );
  }

  Future<void> _onRemoveLikedCat(
    RemoveLikedCat event,
    Emitter<LikedCatsState> emit,
  ) async {
    if (state is LikedCatsLoaded) {
      final currentState = state as LikedCatsLoaded;
      final updatedCats = currentState.likedCats
          .where((cat) => cat.id != event.cat.id)
          .toList();
      final updatedFilteredCats = currentState.filteredCats
          .where((cat) => cat.id != event.cat.id)
          .toList();
      debugPrint(
        'Removed cat in LikedCatsBloc, new total: ${updatedCats.length}',
      );
      emit(
        LikedCatsLoaded(
          likedCats: updatedCats,
          filteredCats: updatedFilteredCats,
          selectedBreed: currentState.selectedBreed,
        ),
      );
    }
  }

  Future<void> _onFilterByBreed(
    FilterByBreed event,
    Emitter<LikedCatsState> emit,
  ) async {
    debugPrint('Received FilterByBreed event with query: "${event.breed}"');
    if (state is LikedCatsLoaded) {
      final currentState = state as LikedCatsLoaded;
      final searchQuery = event.breed;
      final filteredCats = searchQuery.isEmpty
          ? currentState.likedCats
          : currentState.likedCats.where((cat) {
              final breedName = cat.breed.name;
              final matches =
                  breedName.toLowerCase().contains(searchQuery.toLowerCase());
              debugPrint('Checking cat: $breedName, Matches: $matches');
              return matches;
            }).toList();
      debugPrint(
        'Filtered cats: ${filteredCats.length} for query: "$searchQuery"',
      );
      emit(
        LikedCatsLoaded(
          likedCats: currentState.likedCats,
          filteredCats: filteredCats,
          selectedBreed: searchQuery,
        ),
      );
    } else {
      debugPrint('Filter ignored: State is $state, not LikedCatsLoaded');
    }
  }
}
