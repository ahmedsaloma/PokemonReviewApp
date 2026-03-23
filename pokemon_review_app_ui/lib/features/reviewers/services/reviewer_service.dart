import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../models/reviewer.dart';

class ReviewerService {
  static Future<List<Reviewer>> fetchAll() async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Reviewer'));
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
