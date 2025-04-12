import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kototinder/domain/entities/cat.dart';
import 'package:kototinder/di/injection.dart';
import 'package:kototinder/presentation/blocs/home/home_bloc.dart';
import 'package:kototinder/presentation/blocs/home/home_event.dart';
import 'package:kototinder/presentation/blocs/liked_cats/liked_cats_bloc.dart';
import 'package:kototinder/presentation/blocs/liked_cats/liked_cats_event.dart';
import 'package:kototinder/presentation/blocs/liked_cats/liked_cats_state.dart';
import 'package:kototinder/presentation/screens/detail_page.dart';

class LikedCatsPage extends StatefulWidget {
  final List<Cat> likedCats;

  const LikedCatsPage({super.key, required this.likedCats});

  @override
  State<LikedCatsPage> createState() => _LikedCatsPageState();
}

class _LikedCatsPageState extends State<LikedCatsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) =>
            LikedCatsBloc()..add(LoadLikedCats(widget.likedCats)),
        child: Scaffold(
          appBar: AppBar(title: const Text('Liked Cats')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Builder(
                  builder: (innerContext) => TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by breed',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          innerContext
                              .read<LikedCatsBloc>()
                              .add(const FilterByBreed(''));
                        },
                      ),
                    ),
                    onChanged: (value) {
                      final query = value.trim();
                      debugPrint('Search query entered: "$query"');
                      innerContext
                          .read<LikedCatsBloc>()
                          .add(FilterByBreed(query));
                    },
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<LikedCatsBloc, LikedCatsState>(
                  builder: (context, state) {
                    debugPrint('LikedCatsBloc state: $state');
                    if (state is LikedCatsInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LikedCatsLoaded &&
                        state.filteredCats.isEmpty) {
                      return Center(
                        child: Text(
                          state.likedCats.isEmpty
                              ? 'No liked cats yet'
                              : 'No cats match the filter',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    } else if (state is LikedCatsLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(12.0),
                        itemCount: state.filteredCats.length,
                        itemBuilder: (context, index) {
                          final cat = state.filteredCats[index];
                          return Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: SizedBox(
                                width: 70,
                                height: 70,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: cat.imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              title: Text(
                                cat.breed.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: cat.likedAt != null
                                  ? Text(
                                      'Liked on: ${DateFormat.yMMMd().format(cat.likedAt!)}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    )
                                  : null,
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  debugPrint('Deleting cat: ${cat.breed.name}');
                                  context
                                      .read<LikedCatsBloc>()
                                      .add(RemoveLikedCat(cat));
                                  getIt<HomeBloc>()
                                      .add(RemoveLikedCatFromHome(cat));
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(cat: cat),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: Text('Unexpected state'));
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
