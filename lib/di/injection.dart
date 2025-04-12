import 'package:get_it/get_it.dart';
import 'package:kototinder/data/services/cat_api_service.dart';
import 'package:kototinder/domain/repositories/cat_repository.dart';
import 'package:kototinder/presentation/blocs/home/home_bloc.dart';
import 'package:kototinder/presentation/blocs/home/home_event.dart';
import 'package:kototinder/presentation/blocs/liked_cats/liked_cats_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<CatApiService>(CatApiService());
  getIt.registerSingleton<CatRepository>(
    CatRepositoryImpl(getIt<CatApiService>()),
  );

  final homeBloc = HomeBloc(getIt<CatRepository>());
  homeBloc.add(const FetchCat(count: 5));
  getIt.registerSingleton<HomeBloc>(homeBloc);

  getIt.registerFactory<LikedCatsBloc>(() => LikedCatsBloc());
}
