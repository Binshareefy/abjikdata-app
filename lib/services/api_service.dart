import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://abjikdata.com.ng';
  static String? _token;
  static String? _csrfToken;

  static void setToken(String? token) {
    _token = token;
  }

  static void setCsrfToken(String? token) {
    _csrfToken = token;
  }

  static Map<String, String> get _headers => {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
    if (_token != null) 'Authorization': 'Bearer $_token',
    if (_csrfToken != null) 'X-CSRF-TOKEN': _csrfToken ?? '',
  };

  // Helper to convert Map to form-encoded body
  static String _formEncode(Map<String, dynamic> data) {
    return data.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }

  // Auth
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: _headers,
      body: _formEncode({'email': email, 'password': password}),
    );
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/register'),
      headers: _headers,
      body: _formEncode(data),
    );
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/forgot-password'),
      headers: _headers,
      body: _formEncode({'email': email}),
    );
    return _parseResponse(res);
  }

  // Dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/dashboard'),
      headers: _headers,
    );
    return _parseResponse(res);
  }

  // Services
  static Future<Map<String, dynamic>> getDataPlans({String? network}) async {
    final uri = Uri.parse('$baseUrl/api/data-plans').replace(
      queryParameters: network != null ? {'network': network} : null,
    );
    final res = await http.get(uri, headers: _headers);
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> purchaseData(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/data/purchase'),
      headers: _headers,
      body: _formEncode(data),
    );
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> purchaseAirtime(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/airtime/purchase'),
      headers: _headers,
      body: _formEncode(data),
    );
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> getElectricityProviders() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/electricity/providers'),
      headers: _headers,
    );
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> payElectricity(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/electricity/pay'),
      headers: _headers,
      body: _formEncode(data),
    );
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> getCablePlans({String? provider}) async {
    final uri = Uri.parse('$baseUrl/api/cable/plans').replace(
      queryParameters: provider != null ? {'provider': provider} : null,
    );
    final res = await http.get(uri, headers: _headers);
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> subscribeCable(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/cable/subscribe'),
      headers: _headers,
      body: _formEncode(data),
    );
    return _parseResponse(res);
  }

  // Transactions
  static Future<Map<String, dynamic>> getTransactions({int page = 1, String? type}) async {
    final uri = Uri.parse('$baseUrl/api/transactions').replace(
      queryParameters: {
        'page': page.toString(),
        if (type != null) 'type': type,
      },
    );
    final res = await http.get(uri, headers: _headers);
    return _parseResponse(res);
  }

  // Referrals
  static Future<Map<String, dynamic>> getReferrals() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/referrals'),
      headers: _headers,
    );
    return _parseResponse(res);
  }

  // Profile
  static Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/profile'),
      headers: _headers,
    );
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/profile'),
      headers: _headers,
      body: _formEncode(data),
    );
    return _parseResponse(res);
  }

  // Verification
  static Future<Map<String, dynamic>> verifyNin(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/verify/nin'),
      headers: _headers,
      body: _formEncode(data),
    );
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> verifyBvn(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/verify/bvn'),
      headers: _headers,
      body: _formEncode(data),
    );
    return _parseResponse(res);
  }

  // Banners
  static Future<Map<String, dynamic>> getBanners() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/banners'),
      headers: _headers,
    );
    return _parseResponse(res);
  }

  // Parse response - handles both JSON and HTML responses
  static Map<String, dynamic> _parseResponse(http.Response res) {
    try {
      return jsonDecode(res.body);
    } catch (_) {
      // If not JSON, return a structured error
      return {
        'status': 'error',
        'message': 'Server returned an invalid response. Status: ${res.statusCode}',
        'code': res.statusCode,
      };
    }
  }
}
