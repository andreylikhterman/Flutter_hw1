import 'package:kototinder/data/services/cat_api_service.dart';
import 'package:kototinder/domain/entities/breed.dart';
import 'package:kototinder/domain/entities/cat.dart';

abstract class CatRepository {
  Future<List<Cat>> fetchCats({int limit});
}

class CatRepositoryImpl implements CatRepository {
  final CatApiService apiService;

  CatRepositoryImpl(this.apiService);

  @override
  Future<List<Cat>> fetchCats({int limit = 1}) async {
    final catModels = await apiService.fetchCats(limit: limit);
    return catModels
        .map(
          (model) => Cat(
            id: model.id,
            imageUrl: model.imageUrl,
            breed: Breed(
              id: model.breed.id,
              name: model.breed.name,
              temperament: model.breed.temperament,
              origin: model.breed.origin,
              description: model.breed.description,
            ),
            likedAt: model.likedAt,
          ),
        )
        .toList();
  }
}
