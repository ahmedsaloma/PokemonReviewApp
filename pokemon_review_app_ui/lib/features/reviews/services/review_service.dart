import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../models/review.dart';

class ReviewService {
  static Future<List<Review>> fetchByPokemon(int pokemonId) async {
    // Correct route: GET api/Review/pokemon/{pokeId}
    final res = await http.get(
        Uri.parse('${ApiConstants.baseUrl}Review/pokemon/$pokemonId'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List)
          .map((e) => Review.fromJson(e))
          .toList();
    }
    throw Exception('Failed to load reviews (status ${res.statusCode})');
  }

  static Future<List<Review>> fetchByReviewer(int reviewerId) async {
    final res = await http.get(
        Uri.parse('${ApiConstants.baseUrl}Reviewer/$reviewerId/reviews'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List)
          .map((e) => Review.fromJson(e))
          .toList();
    }
    throw Exception('Failed to load reviewer reviews (status ${res.statusCode})');
  }

  static Future<void> create({
    required String title,
    required String text,
    required int rating,
    required int pokemonId,
    required String token,
  }) async {
    // pokeId goes as query param; body only needs title, text, rating. reviewerId is determined from token in backend.
    final body = jsonEncode({
      'title': title,
      'text': text,
      'rating': rating,
    });
    final res = await http.post(
      Uri.parse(
          '${ApiConstants.baseUrl}Review?pokeId=$pokemonId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to post review (status ${res.statusCode}): ${res.body}');
    }
  }

  static Future<void> delete(int reviewId, String token) async {
    final res = await http
        .delete(Uri.parse('${ApiConstants.baseUrl}Review/$reviewId'),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Failed to delete review (status ${res.statusCode})');
    }
  }
}
