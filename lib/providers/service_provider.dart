import 'package:flutter/material.dart';
import '../models/data_plan.dart';
import '../models/transaction.dart';
import '../models/banner_item.dart';
import '../services/api_service.dart';

class ServiceProvider extends ChangeNotifier {
  // Dashboard
  Map<String, dynamic>? _dashboard;
  bool _dashboardLoading = false;

  // Banners
  List<BannerItem> _banners = [];
  bool _bannersLoading = false;

  // Data Plans
  List<DataPlan> _dataPlans = [];
  bool _dataPlansLoading = false;
  String _selectedNetwork = 'all';

  // Transactions
  List<Transaction> _transactions = [];
  bool _transactionsLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;

  // Referrals
  Map<String, dynamic>? _referralData;
  bool _referralsLoading = false;

  // Electricity
  List<ElectricityProvider> _electricityProviders = [];
  bool _electricityLoading = false;

  // Cable
  List<CableProvider> _cableProviders = [];
  bool _cableLoading = false;

  // Service Purchase
  bool _purchasing = false;
  String? _purchaseMessage;

  // Getters
  Map<String, dynamic>? get dashboard => _dashboard;
  bool get dashboardLoading => _dashboardLoading;
  List<DataPlan> get dataPlans => _dataPlans;
  bool get dataPlansLoading => _dataPlansLoading;
  String get selectedNetwork => _selectedNetwork;
  List<Transaction> get transactions => _transactions;
  bool get transactionsLoading => _transactionsLoading;
  bool get hasMore => _hasMore;
  Map<String, dynamic>? get referralData => _referralData;
  bool get referralsLoading => _referralsLoading;
  List<ElectricityProvider> get electricityProviders => _electricityProviders;
  bool get electricityLoading => _electricityLoading;
  List<CableProvider> get cableProviders => _cableProviders;
  bool get cableLoading => _cableLoading;
  bool get purchasing => _purchasing;
  String? get purchaseMessage => _purchaseMessage;
  List<BannerItem> get banners => _banners;
  bool get bannersLoading => _bannersLoading;

  Future<void> fetchDashboard() async {
    _dashboardLoading = true;
    notifyListeners();
    try {
      final res = await ApiService.getDashboard();
      if (res['status'] == 'success') {
        _dashboard = res['data'] ?? res;
      }
    } catch (_) {}
    _dashboardLoading = false;
    notifyListeners();
  }

  Future<void> fetchBanners() async {
    _bannersLoading = true;
    notifyListeners();
    try {
      final res = await ApiService.getBanners();
      if (res['status'] == 'success') {
        final list = res['data'] ?? res['banners'] ?? [];
        _banners = (list as List)
            .map((e) => BannerItem.fromJson(e))
            .where((b) => b.isActive)
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      }
    } catch (_) {}
    _bannersLoading = false;
    notifyListeners();
  }

  Future<void> fetchDataPlans({String? network}) async {
    _dataPlansLoading = true;
    _selectedNetwork = network ?? 'all';
    notifyListeners();
    try {
      final res = await ApiService.getDataPlans(network: network);
      if (res['status'] == 'success') {
        final list = res['data'] ?? res['plans'] ?? [];
        _dataPlans = (list as List).map((e) => DataPlan.fromJson(e)).toList();
      }
    } catch (_) {}
    _dataPlansLoading = false;
    notifyListeners();
  }

  Future<bool> purchaseData({
    required String planId,
    required String phone,
    required String pin,
  }) async {
    _purchasing = true;
    _purchaseMessage = null;
    notifyListeners();
    try {
      final res = await ApiService.purchaseData({
        'plan_id': planId,
        'phone': phone,
        'pin': pin,
      });
      _purchasing = false;
      if (res['status'] == 'success') {
        _purchaseMessage = res['message'] ?? 'Purchase successful!';
        notifyListeners();
        return true;
      } else {
        _purchaseMessage = res['message'] ?? 'Purchase failed';
        notifyListeners();
        return false;
      }
    } catch (_) {
      _purchasing = false;
      _purchaseMessage = 'Connection error';
      notifyListeners();
      return false;
    }
  }

  Future<bool> purchaseAirtime({
    required String network,
    required String phone,
    required double amount,
    required String pin,
  }) async {
    _purchasing = true;
    _purchaseMessage = null;
    notifyListeners();
    try {
      final res = await ApiService.purchaseAirtime({
        'network': network,
        'phone': phone,
        'amount': amount,
        'pin': pin,
      });
      _purchasing = false;
      if (res['status'] == 'success') {
        _purchaseMessage = res['message'] ?? 'Airtime purchase successful!';
        notifyListeners();
        return true;
      } else {
        _purchaseMessage = res['message'] ?? 'Purchase failed';
        notifyListeners();
        return false;
      }
    } catch (_) {
      _purchasing = false;
      _purchaseMessage = 'Connection error';
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchTransactions({bool loadMore = false}) async {
    if (loadMore && !_hasMore) return;
    _transactionsLoading = true;
    notifyListeners();
    try {
      final page = loadMore ? _currentPage + 1 : 1;
      final res = await ApiService.getTransactions(page: page);
      if (res['status'] == 'success') {
        final list = res['data'] ?? res['transactions'] ?? [];
        final txns = (list as List).map((e) => Transaction.fromJson(e)).toList();
        if (loadMore) {
          _transactions.addAll(txns);
          _currentPage = page;
        } else {
          _transactions = txns;
          _currentPage = 1;
        }
        _hasMore = txns.length >= 20;
      }
    } catch (_) {}
    _transactionsLoading = false;
    notifyListeners();
  }

  Future<void> fetchReferrals() async {
    _referralsLoading = true;
    notifyListeners();
    try {
      final res = await ApiService.getReferrals();
      if (res['status'] == 'success') {
        _referralData = res['data'] ?? res;
      }
    } catch (_) {}
    _referralsLoading = false;
    notifyListeners();
  }

  Future<void> fetchElectricityProviders() async {
    _electricityLoading = true;
    notifyListeners();
    try {
      final res = await ApiService.getElectricityProviders();
      if (res['status'] == 'success') {
        final list = res['data'] ?? res['providers'] ?? [];
        _electricityProviders = (list as List)
            .map((e) => ElectricityProvider.fromJson(e))
            .toList();
      }
    } catch (_) {}
    _electricityLoading = false;
    notifyListeners();
  }

  void clearPurchaseMessage() {
    _purchaseMessage = null;
    notifyListeners();
  }
}
