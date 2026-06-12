import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/service_button.dart';
import '../../widgets/transaction_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceProvider>().fetchDashboard();
      context.read<ServiceProvider>().fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final service = context.watch<ServiceProvider>();
    final currencyFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 2);
    final user = auth.user;

    return SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await service.fetchDashboard();
            await service.fetchTransactions();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        (user?.username.isNotEmpty == true)
                            ? user!.username[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${user?.username ?? 'User'} 👋',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      color: AppColors.muted,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Balance Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Wallet Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currencyFormat.format(user?.balance ?? 0.0),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _BalanceAction(
                            icon: Icons.add,
                            label: 'Fund',
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          _BalanceAction(
                            icon: Icons.send,
                            label: 'Transfer',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // KPIs
                if (service.dashboard != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: KpiCard(
                          label: 'Success Rate',
                          value: service.dashboard!['success_rate']?.toString() ?? '0%',
                          icon: Icons.check_circle,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: KpiCard(
                          label: 'Referral Earnings',
                          value: currencyFormat.format(
                            double.tryParse(
                                    service.dashboard!['referral_earnings']?.toString() ?? '0') ??
                                0.0,
                          ),
                          icon: Icons.card_giftcard,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // Quick Actions
                const Text(
                  'Quick Services',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.85,
                  children: [
                    ServiceButton(
                      icon: Icons.wifi,
                      label: 'Data',
                      color: AppColors.info,
                      onTap: () => Navigator.pushNamed(context, '/data'),
                    ),
                    ServiceButton(
                      icon: Icons.phone_android,
                      label: 'Airtime',
                      color: AppColors.primary,
                      onTap: () => Navigator.pushNamed(context, '/airtime'),
                    ),
                    ServiceButton(
                      icon: Icons.bolt,
                      label: 'Electricity',
                      color: AppColors.warning,
                      onTap: () => Navigator.pushNamed(context, '/electricity'),
                    ),
                    ServiceButton(
                      icon: Icons.tv,
                      label: 'Cable TV',
                      color: AppColors.success,
                      onTap: () {},
                    ),
                    ServiceButton(
                      icon: Icons.person_search,
                      label: 'Verify NIN',
                      color: AppColors.danger,
                      onTap: () => Navigator.pushNamed(context, '/verify-nin'),
                    ),
                    ServiceButton(
                      icon: Icons.credit_card,
                      label: 'BVN',
                      color: AppColors.primary,
                      onTap: () => Navigator.pushNamed(context, '/verify-bvn'),
                    ),
                    ServiceButton(
                      icon: Icons.privacy_tip,
                      label: 'Verify IP',
                      color: AppColors.info,
                      onTap: () {},
                    ),
                    ServiceButton(
                      icon: Icons.price_change,
                      label: 'Pricing',
                      color: AppColors.warning,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Recent Transactions
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                ...service.transactions.take(5).map(
                      (txn) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TransactionTile(transaction: txn),
                      ),
                    ),
              ],
            ),
          ),
        ),
    );
  }
}

class _BalanceAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BalanceAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
