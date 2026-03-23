import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../models/category.dart';
import '../../pokemon/models/pokemon.dart';

class CategoryService {
  static Future<List<Category>> fetchAll() async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Category'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => Category.fromJson(e)).toList();
    }
    throw Exception('Failed to load categories');
  }

  static Future<List<Pokemon>> fetchPokemonByCategory(int categoryId) async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Category/$categoryId/pokemon'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => Pokemon.fromJson(e)).toList();
    }
    throw Exception('Failed to load pokemon for category');
  }
}
