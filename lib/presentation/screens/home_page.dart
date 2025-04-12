import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kototinder/di/injection.dart';
import 'package:kototinder/domain/entities/cat.dart';
import 'package:kototinder/presentation/blocs/home/home_bloc.dart';
import 'package:kototinder/presentation/blocs/home/home_event.dart';
import 'package:kototinder/presentation/blocs/home/home_state.dart';
import 'package:kototinder/presentation/screens/detail_page.dart';
import 'package:kototinder/presentation/screens/liked_cats_page.dart';
import 'package:kototinder/presentation/widgets/action_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Building HomePage');
    return BlocProvider(
      create: (context) {
        final bloc = getIt<HomeBloc>();
        debugPrint('Creating HomeBloc, dispatching FetchCat(count: 5)');
        bloc.add(const FetchCat(count: 5));
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cat Tinder'),
          backgroundColor: Colors.pink,
          actions: [
            Builder(
              builder: (innerContext) => IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  final likedCats = innerContext.read<HomeBloc>().likedCats;
                  debugPrint(
                    'Navigating to LikedCatsPage with ${likedCats.length} cats',
                  );
                  Navigator.push(
                    innerContext,
                    MaterialPageRoute(
                      builder: (context) => LikedCatsPage(likedCats: likedCats),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            debugPrint('HomeBloc listener: $state');
            if (state is HomeError) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        debugPrint(
                          'Retry pressed, dispatching FetchCat(count: 5)',
                        );
                        Navigator.pop(context);
                        context.read<HomeBloc>().add(const FetchCat(count: 5));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            debugPrint('HomeBloc builder: $state');
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    if (state is HomeInitial || state is HomeLoading) {
      debugPrint('Rendering CircularProgressIndicator for $state');
      return const Center(child: CircularProgressIndicator());
    } else if (state is HomeLoaded) {
      debugPrint('HomeLoaded with ${state.cats.length} cats');
      if (state.cats.isEmpty) {
        debugPrint('No cats available');
        return const Center(child: Text('No cats available'));
      }
      final currentCat = state.cats.first;
      if (state.cats.length <= 2) {
        debugPrint('Cats <= 2, dispatching FetchCat(count: 5)');
        context.read<HomeBloc>().add(const FetchCat(count: 5));
      }
      return FutureBuilder(
        future: precacheImage(NetworkImage(currentCat.imageUrl), context),
        builder: (context, snapshot) {
          debugPrint('FutureBuilder state: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint('Precache error: ${snapshot.error}');
            return const Center(child: Text('Failed to load image'));
          }
          return _buildCatCard(context, currentCat, state.likeCount);
        },
      );
    } else if (state is HomeError) {
      debugPrint('HomeError: ${state.message}');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),
            ElevatedButton(
              onPressed: () {
                debugPrint('Retry pressed, dispatching FetchCat(count: 5)');
                context.read<HomeBloc>().add(const FetchCat(count: 5));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    debugPrint('Fallback to CircularProgressIndicator');
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildCatCard(BuildContext context, Cat cat, int likeCount) {
    debugPrint('Building cat card for ${cat.breed.name}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Expanded(
            child: Card(
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity != null) {
                    if (details.primaryVelocity! > 0) {
                      debugPrint('Swiped right: Liking ${cat.breed.name}');
                      context.read<HomeBloc>().add(LikeCat(cat));
                    } else if (details.primaryVelocity! < 0) {
                      debugPrint('Swiped left: Disliking');
                      context.read<HomeBloc>().add(DislikeCat());
                    }
                  }
                },
                onTap: () {
                  debugPrint('Tapped card, navigating to DetailPage');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(cat: cat),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    imageUrl: cat.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              cat.breed.name,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
            child: Text(
              'Likes: $likeCount',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionButton(
                  icon: Icons.close_rounded,
                  color: Colors.redAccent.shade400,
                  onPressed: () {
                    debugPrint('Pressed dislike button');
                    context.read<HomeBloc>().add(DislikeCat());
                  },
                ),
                ActionButton(
                  icon: Icons.favorite_rounded,
                  color: Colors.greenAccent.shade400,
                  onPressed: () {
                    debugPrint('Pressed like button: Liking ${cat.breed.name}');
                    context.read<HomeBloc>().add(LikeCat(cat));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
