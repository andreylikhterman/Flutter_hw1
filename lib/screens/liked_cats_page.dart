import 'package:flutter/material.dart';
import 'package:kototinder/models/cat.dart';
import 'package:kototinder/screens/detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LikedCatsPage extends StatelessWidget {
  const LikedCatsPage({
    super.key,
    required this.likedCats,
  });

  final List<Cat> likedCats;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Liked Cats')),
        body: likedCats.isEmpty
            ? Center(
                child: Text(
                  'No liked cats yet',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: likedCats.length,
                itemBuilder: (context, index) {
                  final cat = likedCats[index];
                  return Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
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
                      subtitle: Text(
                        cat.breed.temperament,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
              ),
      );
}
