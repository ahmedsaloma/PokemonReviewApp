import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../models/reviewer.dart';

class ReviewerService {
  static Future<List<Reviewer>> fetchAll({String? searchTerm}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}Reviewer').replace(
      queryParameters: searchTerm != null && searchTerm.trim().isNotEmpty
          ? {'searchTerm': searchTerm.trim()}
          : null,
    );

    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => Reviewer.fromJson(e)).toList();
    }
    throw Exception('Failed to load reviewers');
  }

  static Future<Reviewer> fetchById(int id) async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Reviewer/$id'));
    if (res.statusCode == 200) return Reviewer.fromJson(jsonDecode(res.body));
    throw Exception('Failed to load reviewer');
  }
}
