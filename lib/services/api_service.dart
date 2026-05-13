import 'dart:convert';
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
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  Future<Map<String, dynamic>> login(String nim) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': nim, 'password': nim}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['data']?['token'] ?? data['token'];
        if (token != null) await saveToken(token);
      }

      return data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<List<Product>> getProduct() async {
    final url = Uri.parse('$baseUrl/api/products');
    final headers = await _authHeaders();

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final raw = data['data']?['Products'] ?? data['data']?['products'] ?? [];
        final list = raw as List;
        return list.map((e) => Product.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> createProduct(String name, int price, String description) async {
    final url = Uri.parse('$baseUrl/api/products');
    final headers = await _authHeaders();

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

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
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

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
