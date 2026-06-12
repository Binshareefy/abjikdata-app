import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://abjikdata.com.ng';
  static String? _token;

  static void setToken(String? token) {
    _token = token;
  }

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Auth
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/login.php'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/register.php'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/forgot_password.php'),
      headers: _headers,
      body: jsonEncode({'email': email}),
    );
    return jsonDecode(res.body);
  }

  // Dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/dashboard.php'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  // Services
  static Future<Map<String, dynamic>> getDataPlans({String? network}) async {
    final uri = Uri.parse('$baseUrl/api/data_plans.php').replace(
      queryParameters: network != null ? {'network': network} : null,
    );
    final res = await http.get(uri, headers: _headers);
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> purchaseData(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/purchase_data.php'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> purchaseAirtime(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/purchase_airtime.php'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getElectricityProviders() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/electricity_providers.php'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> payElectricity(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/pay_electricity.php'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getCablePlans({String? provider}) async {
    final uri = Uri.parse('$baseUrl/api/cable_plans.php').replace(
      queryParameters: provider != null ? {'provider': provider} : null,
    );
    final res = await http.get(uri, headers: _headers);
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> subscribeCable(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/subscribe_cable.php'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  // Transactions
  static Future<Map<String, dynamic>> getTransactions({int page = 1, String? type}) async {
    final uri = Uri.parse('$baseUrl/api/transactions.php').replace(
      queryParameters: {
        'page': page.toString(),
        if (type != null) 'type': type,
      },
    );
    final res = await http.get(uri, headers: _headers);
    return jsonDecode(res.body);
  }

  // Referrals
  static Future<Map<String, dynamic>> getReferrals() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/referrals.php'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  // Profile
  static Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/profile.php'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/profile.php'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  // Verification
  static Future<Map<String, dynamic>> verifyNin(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/verify_nin.php'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> verifyBvn(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/verify_bvn.php'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }
}
