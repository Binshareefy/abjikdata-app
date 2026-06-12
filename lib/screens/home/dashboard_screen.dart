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

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceProvider>().fetchDashboard();
      context.read<ServiceProvider>().fetchTransactions();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final service = context.watch<ServiceProvider>();
    final currencyFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 2);
    final user = auth.user;

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
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
              _buildHeader(user),
              const SizedBox(height: 24),

              // Balance Card
              _buildBalanceCard(user, currencyFormat),
              const SizedBox(height: 20),

              // KPIs
              if (service.dashboard != null) ...[
                _buildKpiRow(service, currencyFormat),
                const SizedBox(height: 20),
              ],

              // Quick Services
              _buildSectionTitle('Quick Services'),
              const SizedBox(height: 12),
              _buildServicesGrid(),
              const SizedBox(height: 20),

              // Recent Transactions
              _buildSectionTitle('Recent Transactions'),
              const SizedBox(height: 12),
              if (service.transactionsLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                )
              else if (service.transactions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.receipt_long_outlined,
                          size: 48, color: AppColors.muted.withOpacity(0.5)),
                      const SizedBox(height: 12),
                      const Text(
                        'No transactions yet',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...service.transactions.take(5).map(
                      (txn) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TransactionTile(transaction: txn),
                      ),
                    ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(user) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      (user?.username?.isNotEmpty == true)
                          ? user!.username[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
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
        Container(
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.muted,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(user, currencyFormat) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Wallet Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility, color: Colors.white70, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'NGN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(user?.balance ?? 0.0),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _BalanceAction(
                  icon: Icons.add_rounded,
                  label: 'Fund Wallet',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _BalanceAction(
                  icon: Icons.swap_horiz_rounded,
                  label: 'Transfer',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiRow(service, currencyFormat) {
    return Row(
      children: [
        Expanded(
          child: KpiCard(
            label: 'Success Rate',
            value: service.dashboard!['success_rate']?.toString() ?? '0%',
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: KpiCard(
            label: 'Referral Earnings',
            value: currencyFormat.format(
              double.tryParse(service.dashboard!['referral_earnings']
                          ?.toString() ??
                      '0') ??
                  0.0,
            ),
            icon: Icons.card_giftcard_rounded,
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        if (title == 'Recent Transactions')
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/transactions'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'See All',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildServicesGrid() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.85,
      children: [
        ServiceButton(
          icon: Icons.wifi_rounded,
          label: 'Data',
          color: AppColors.info,
          onTap: () => Navigator.pushNamed(context, '/data'),
        ),
        ServiceButton(
          icon: Icons.phone_android_rounded,
          label: 'Airtime',
          color: AppColors.primary,
          onTap: () => Navigator.pushNamed(context, '/airtime'),
        ),
        ServiceButton(
          icon: Icons.bolt_rounded,
          label: 'Electricity',
          color: AppColors.warning,
          onTap: () => Navigator.pushNamed(context, '/electricity'),
        ),
        ServiceButton(
          icon: Icons.tv_rounded,
          label: 'Cable TV',
          color: AppColors.success,
          onTap: () {},
        ),
        ServiceButton(
          icon: Icons.credit_card_rounded,
          label: 'NIN',
          color: AppColors.danger,
          onTap: () => Navigator.pushNamed(context, '/verify-nin'),
        ),
        ServiceButton(
          icon: Icons.badge_rounded,
          label: 'BVN',
          color: AppColors.primary,
          onTap: () => Navigator.pushNamed(context, '/verify-bvn'),
        ),
        ServiceButton(
          icon: Icons.verified_user_rounded,
          label: 'Verify IP',
          color: AppColors.info,
          onTap: () {},
        ),
        ServiceButton(
          icon: Icons.monetization_on_rounded,
          label: 'Pricing',
          color: AppColors.warning,
          onTap: () {},
        ),
      ],
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
    return Material(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
