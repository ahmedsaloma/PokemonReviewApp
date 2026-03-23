import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../models/country.dart';
import '../../owners/models/owner.dart';

class CountryService {
  static Future<List<Country>> fetchAll() async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Country'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => Country.fromJson(e)).toList();
    }
    throw Exception('Failed to load countries');
  }

  static Future<Country> fetchById(int id) async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Country/$id'));
    if (res.statusCode == 200) return Country.fromJson(jsonDecode(res.body));
    throw Exception('Failed to load country');
  }

  static Future<List<Owner>> fetchOwnersByCountry(int countryId) async {
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}Country/$countryId/owners'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => Owner.fromJson(e)).toList();
    }
    throw Exception('Failed to load owners for country');
  }
}
