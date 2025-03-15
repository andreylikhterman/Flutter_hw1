import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kototinder/models/cat.dart';
import 'package:kototinder/screens/detail_page.dart';
import 'package:kototinder/screens/liked_cats_page.dart';
import 'package:kototinder/widgets/action_button.dart';

const String _apiKey =
    'live_5ErNopGDGu2Q4HFAKnI625MhHLBrybgbvqnw6ohPI6wu1L6IuDiN2hbBecXTOe3j';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Cat? _currentCat;
  final List<Cat> _likedCats = [];
  int _likeCount = 0;
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _fetchCat();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchCat() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final catData = await _fetchCatData();
      if (catData != null && catData.isNotEmpty) {
        final cat = Cat.fromJson(catData[0]);
        setState(() {
          _currentCat = cat;
        });
      } else {
        setState(() {
          _errorMessage = 'No cats found.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<dynamic>?> _fetchCatData() async {
    final url =
        Uri.parse('https://api.thecatapi.com/v1/images/search?has_breeds=1');
    final response = await http.get(
      url,
      headers: {
        'x-api-key': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      setState(() {
        _errorMessage = 'Server error: ${response.statusCode}';
      });
      return null;
    }
  }

  void _handleSwipe(bool liked) {
    if (liked && _currentCat != null) {
      setState(() {
        _likeCount++;
        _likedCats.add(_currentCat!);
      });
    }
    _fetchCat();
  }

  void _onTapCat() {
    if (_currentCat != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailPage(cat: _currentCat!)),
      );
    }
  }

  Widget _buildLoadingIndicator() => Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            const SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
              ),
            ),
            RotationTransition(
              turns: _animationController,
              child: const Icon(Icons.pets, size: 60, color: Colors.pink),
            ),
          ],
        ),
      );

  Widget _buildErrorView() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchCat,
              child: const Text('Retry'),
            ),
          ],
        ),
      );

  Widget _buildCatCard(BuildContext context) => Expanded(
        child: Card(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! > 0) {
                  _handleSwipe(true);
                } else if (details.primaryVelocity! < 0) {
                  _handleSwipe(false);
                }
              }
            },
            onTap: _onTapCat,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: CachedNetworkImage(
                imageUrl: _currentCat!.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                  ),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildActionButtons() => Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ActionButton(
              icon: Icons.close_rounded,
              color: Colors.redAccent.shade400,
              onPressed: () => _handleSwipe(false),
            ),
            ActionButton(
              icon: Icons.favorite_rounded,
              color: Colors.greenAccent.shade400,
              onPressed: () => _handleSwipe(true),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Cat Tinder'),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LikedCatsPage(likedCats: _likedCats),
                  ),
                );
              },
            ),
          ],
        ),
        body: _isLoading
            ? _buildLoadingIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    if (_errorMessage != null)
                      _buildErrorView()
                    else if (_currentCat == null)
                      const Center(child: Text('No data'))
                    else ...[
                      _buildCatCard(context),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          _currentCat!.breed.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: Text(
                          'Likes: $_likeCount',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      _buildActionButtons(),
                    ],
                  ],
                ),
              ),
      );
}
