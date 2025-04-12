import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kototinder/data/models/cat.dart';

class CatApiService {
  static const String _apiKey =
      'live_5ErNopGDGu2Q4HFAKnI625MhHLBrybgbvqnw6ohPI6wu1L6IuDiN2hbBecXTOe3j';
  static const String _baseUrl = 'https://api.thecatapi.com/v1/images/search';

  Future<List<CatModel>> fetchCats({int limit = 1}) async {
    final url = Uri.parse('$_baseUrl?has_breeds=1&limit=$limit');
    final response = await http.get(
      url,
      headers: {'x-api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CatModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch cats: ${response.statusCode}');
    }
  }
}
