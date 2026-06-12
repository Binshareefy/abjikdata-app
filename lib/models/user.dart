class User {
  final int id;
  final String username;
  final String email;
  final String phone;
  final double balance;
  final double referralEarnings;
  final String? avatar;
  final String? referralCode;
  final String? referralLink;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.balance = 0.0,
    this.referralEarnings = 0.0,
    this.avatar,
    this.referralCode,
    this.referralLink,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
      referralEarnings: double.tryParse(json['referral_earnings']?.toString() ?? '0') ?? 0.0,
      avatar: json['avatar'],
      referralCode: json['referral_code'],
      referralLink: json['referral_link'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'phone': phone,
    'balance': balance,
    'referral_earnings': referralEarnings,
    'avatar': avatar,
    'referral_code': referralCode,
    'referral_link': referralLink,
  };
}
