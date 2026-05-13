import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pbm_tugas_praktikum/models/product_model.dart';

class ApiService {
  final String baseUrl = 'https://task.itprojects.web.id';
  final storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    if (token == null) {
      developer.log('[ApiService] WARNING: token null, request mungkin ditolak server!');
    } else {
      developer.log('[ApiService] Token ditemukan: ${token.substring(0, token.length.clamp(0, 20))}...');
    }
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  // ──────────────────────────────────────────────
  // AUTH
  // ──────────────────────────────────────────────
  Future<Map<String, dynamic>> login(String nim) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    developer.log('[ApiService] POST $url  body: {username: $nim}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': nim, 'password': nim}),
      );

      developer.log('[ApiService] login status: ${response.statusCode}');
      developer.log('[ApiService] login body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Coba dua kemungkinan struktur: data['token'] atau data['data']['token']
        final token = data['data']?['token'] ?? data['token'];
        if (token != null) {
          await saveToken(token);
          developer.log('[ApiService] Token tersimpan.');
        } else {
          developer.log('[ApiService] WARNING: Token tidak ditemukan di response!');
        }
      }

      return data;
    } catch (e) {
      developer.log('[ApiService] login error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ──────────────────────────────────────────────
  // PRODUCTS
  // ──────────────────────────────────────────────
  Future<List<Product>> getProduct() async {
    final url = Uri.parse('$baseUrl/api/products');
    final headers = await _authHeaders();
    developer.log('[ApiService] GET $url');

    try {
      final response = await http.get(url, headers: headers);
      developer.log('[ApiService] getProduct status: ${response.statusCode}');
      developer.log('[ApiService] getProduct body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Coba dua kemungkinan key: 'products' atau 'Products'
        final raw = data['data']?['products'] ?? data['data']?['Products'] ?? [];
        final list = raw as List;
        return list.map((e) => Product.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      developer.log('[ApiService] getProduct error: $e');
      return [];
    }
  }

  Future<bool> createProduct(
    String name,
    int price,
    String description,
  ) async {
    final url = Uri.parse('$baseUrl/api/products');
    final headers = await _authHeaders();
    developer.log('[ApiService] POST $url  name=$name price=$price');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
        }),
      );

      developer.log('[ApiService] createProduct status: ${response.statusCode}');
      developer.log('[ApiService] createProduct body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      developer.log('[ApiService] createProduct error: $e');
      return false;
    }
  }


  Future<bool> submitTugas(
    String name,
    int price,
    String description,
    String githubUrl,
  ) async {
    final url = Uri.parse('$baseUrl/api/products/submit');
    final headers = await _authHeaders();
    developer.log('[ApiService] POST $url  name=$name githubUrl=$githubUrl');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
          'github_url': githubUrl,
        }),
      );

      developer.log('[ApiService] submitTugas status: ${response.statusCode}');
      developer.log('[ApiService] submitTugas body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      developer.log('[ApiService] submitTugas error: $e');
      return false;
    }
  }
}
