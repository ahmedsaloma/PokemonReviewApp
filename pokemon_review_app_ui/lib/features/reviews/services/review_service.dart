import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../models/review.dart';

class ReviewService {
  static Future<List<Review>> fetchByPokemon(int pokemonId) async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Pokemon/$pokemonId/reviews'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => Review.fromJson(e)).toList();
    }
    throw Exception('Failed to load reviews');
  }

  static Future<List<Review>> fetchByReviewer(int reviewerId) async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Reviewer/$reviewerId/reviews'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => Review.fromJson(e)).toList();
    }
    throw Exception('Failed to load reviewer reviews');
  }

  static Future<void> create({
    required String title,
    required String text,
    required int rating,
    required int reviewerId,
    required int pokemonId,
  }) async {
    final body = jsonEncode({
      'title': title,
      'text': text,
      'rating': rating,
      'reviewer': {'id': reviewerId},
      'pokemon': {'id': pokemonId},
    });
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}Review?reviewerId=$reviewerId&pokeId=$pokemonId'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to post review');
    }
  }

  static Future<void> delete(int reviewId) async {
    final res = await http.delete(Uri.parse('${ApiConstants.baseUrl}Review/$reviewId'));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Failed to delete review');
    }
  }
}
