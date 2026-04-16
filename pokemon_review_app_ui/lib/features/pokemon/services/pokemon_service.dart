import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../models/pokemon.dart';

class PokemonService {
  static Future<List<Pokemon>> fetchAll({String? searchTerm}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}Pokemon').replace(
      queryParameters: searchTerm != null && searchTerm.trim().isNotEmpty
          ? {'searchTerm': searchTerm.trim()}
          : null,
    );

    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => Pokemon.fromJson(e)).toList();
    }
    throw Exception('Failed to load pokemon');
  }

  static Future<Pokemon> fetchById(int id) async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Pokemon/$id'));
    if (res.statusCode == 200) return Pokemon.fromJson(jsonDecode(res.body));
    throw Exception('Failed to load pokemon #$id');
  }

  static Future<double> fetchRating(int id) async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Pokemon/$id/rating'));
    if (res.statusCode == 200) return (jsonDecode(res.body) as num).toDouble();
    throw Exception('Failed to load rating');
  }
}
