class DataPlan {
  final String id;
  final String planName;
  final double price;
  final double? oldPrice;
  final String network;
  final String? size;
  final String? validity;
  final bool isPopular;

  DataPlan({
    required this.id,
    required this.planName,
    required this.price,
    this.oldPrice,
    required this.network,
    this.size,
    this.validity,
    this.isPopular = false,
  });

  factory DataPlan.fromJson(Map<String, dynamic> json) {
    return DataPlan(
      id: json['id']?.toString() ?? '',
      planName: json['plan_name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      oldPrice: double.tryParse(json['old_price']?.toString() ?? ''),
      network: json['network'] ?? '',
      size: json['size'],
      validity: json['validity'],
      isPopular: json['popular'] == true || json['popular'] == '1',
    );
  }
}

class AirtimePlan {
  final String network;
  final double minAmount;
  final double maxAmount;
  final double discount;

  AirtimePlan({
    required this.network,
    this.minAmount = 50,
    this.maxAmount = 50000,
    this.discount = 0.0,
  });
}

class ElectricityProvider {
  final String id;
  final String name;
  final String? logo;
  final double? minAmount;
  final double? maxAmount;

  ElectricityProvider({
    required this.id,
    required this.name,
    this.logo,
    this.minAmount,
    this.maxAmount,
  });

  factory ElectricityProvider.fromJson(Map<String, dynamic> json) {
    return ElectricityProvider(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      logo: json['logo'],
      minAmount: double.tryParse(json['min_amount']?.toString() ?? ''),
      maxAmount: double.tryParse(json['max_amount']?.toString() ?? ''),
    );
  }
}

class CableProvider {
  final String id;
  final String name;
  final List<CablePlan> plans;

  CableProvider({required this.id, required this.name, this.plans = const []});
}

class CablePlan {
  final String id;
  final String name;
  final double price;
  final double? oldPrice;

  CablePlan({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
  });
}
