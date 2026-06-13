import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://abjikdata.com.ng';
  static const String apiEndpoint = '$baseUrl/process.php';
  static String? _sessionCookie;
  static String? _token;

  static String? get sessionCookie => _sessionCookie;

  static void setToken(String? token) {
    _token = token;
  }

  static void setSessionCookie(String? cookie) {
    _sessionCookie = cookie;
  }

  static Map<String, String> get _headers => {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
    if (_sessionCookie != null) 'Cookie': _sessionCookie!,
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Helper to convert Map to form-encoded body
  static String _formEncode(Map<String, dynamic> data) {
    return data.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }

  // Core API call
  static Future<Map<String, dynamic>> _call(String action, Map<String, dynamic> data) async {
    final body = Map<String, dynamic>.from(data);
    body['action'] = action;

    try {
      final res = await http.post(
        Uri.parse(apiEndpoint),
        headers: _headers,
        body: _formEncode(body),
      );

      // Store session cookie from response
      final setCookie = res.headers['set-cookie'];
      if (setCookie != null) {
        _sessionCookie = setCookie.split(';').first;
      }

      return _parseResponse(res);
    } catch (e) {
      return {'status': 'error', 'message': 'Connection error: ${e.toString()}'};
    }
  }

  // Auth
  static Future<Map<String, dynamic>> login(String email, String password) async {
    return _call('login', {
      'email': email,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    return _call('register', data);
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    return _call('forgot_password', {'email': email});
  }

  // Dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    return _call('get_dashboard', {});
  }

  // Services
  static Future<Map<String, dynamic>> getDataPlans({String? network}) async {
    final data = <String, dynamic>{};
    if (network != null && network != 'all') data['network'] = network;
    return _call('get_data_plans', data);
  }

  static Future<Map<String, dynamic>> purchaseData(Map<String, dynamic> data) async {
    return _call('purchase_data', data);
  }

  static Future<Map<String, dynamic>> purchaseAirtime(Map<String, dynamic> data) async {
    return _call('purchase_airtime', data);
  }

  static Future<Map<String, dynamic>> getElectricityProviders() async {
    return _call('get_electricity_providers', {});
  }

  static Future<Map<String, dynamic>> payElectricity(Map<String, dynamic> data) async {
    return _call('pay_electricity', data);
  }

  static Future<Map<String, dynamic>> getCablePlans({String? provider}) async {
    final data = <String, dynamic>{};
    if (provider != null) data['provider'] = provider;
    return _call('get_cable_plans', data);
  }

  static Future<Map<String, dynamic>> subscribeCable(Map<String, dynamic> data) async {
    return _call('subscribe_cable', data);
  }

  // Transactions
  static Future<Map<String, dynamic>> getTransactions({int page = 1, String? type}) async {
    final data = <String, dynamic>{'page': page.toString()};
    if (type != null) data['type'] = type;
    return _call('get_transactions', data);
  }

  // Referrals
  static Future<Map<String, dynamic>> getReferrals() async {
    return _call('get_referrals', {});
  }

  // Profile
  static Future<Map<String, dynamic>> getProfile() async {
    return _call('get_profile', {});
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    return _call('update_profile', data);
  }

  // Verification
  static Future<Map<String, dynamic>> verifyNin(Map<String, dynamic> data) async {
    return _call('verify_nin', data);
  }

  static Future<Map<String, dynamic>> verifyBvn(Map<String, dynamic> data) async {
    return _call('verify_bvn', data);
  }

  // Banners
  static Future<Map<String, dynamic>> getBanners() async {
    return _call('get_banners', {});
  }

  // Parse response
  static Map<String, dynamic> _parseResponse(http.Response res) {
    try {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      return {
        'status': 'error',
        'message': 'Server error. Status: ${res.statusCode}',
      };
    }
  }
}
