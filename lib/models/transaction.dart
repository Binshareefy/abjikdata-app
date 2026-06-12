class Transaction {
  final String id;
  final String type;
  final String status;
  final double amount;
  final String description;
  final DateTime createdAt;
  final String? reference;

  Transaction({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    required this.description,
    required this.createdAt,
    this.reference,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      description: json['description'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      reference: json['reference'],
    );
  }

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
        return 'Successful';
      case 'pending':
        return 'Pending';
      case 'failed':
        return 'Failed';
      default:
        return status;
    }
  }

  String get typeLabel {
    switch (type.toLowerCase()) {
      case 'data':
        return 'Data Purchase';
      case 'airtime':
        return 'Airtime';
      case 'electricity':
        return 'Electricity';
      case 'cable':
        return 'Cable TV';
      case 'funding':
        return 'Funding';
      default:
        return type;
    }
  }
}
