import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../models/owner.dart';
import '../../pokemon/models/pokemon.dart';

class OwnerService {
  static Future<List<Owner>> fetchAll() async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Owner'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => Owner.fromJson(e)).toList();
    }
    throw Exception('Failed to load owners');
  }

  static Future<Owner> fetchById(int id) async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Owner/$id'));
    if (res.statusCode == 200) return Owner.fromJson(jsonDecode(res.body));
    throw Exception('Failed to load owner');
  }

  static Future<List<Pokemon>> fetchOwnerPokemon(int ownerId) async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Owner/$ownerId/pokemon'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => Pokemon.fromJson(e)).toList();
    }
    throw Exception('Failed to load owner pokemon');
  }
}
