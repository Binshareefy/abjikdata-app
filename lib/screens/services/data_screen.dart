import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/service_provider.dart';
import '../../theme/app_colors.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  String _selectedNetwork = 'MTN';
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  String? _selectedPlanId;

  final _networks = ['MTN', 'Glo', 'Airtel', '9mobile'];
  final _networkColors = {
    'MTN': const Color(0xFFFFCC00),
    'Glo': const Color(0xFF00A650),
    'Airtel': const Color(0xFFED1C24),
    '9mobile': const Color(0xFF009A44),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceProvider>().fetchDataPlans();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _purchase() async {
    if (_selectedPlanId == null || _phoneController.text.length < 11) return;
    final service = context.read<ServiceProvider>();
    final success = await service.purchaseData(
      planId: _selectedPlanId!,
      phone: _phoneController.text.trim(),
      pin: _pinController.text,
    );
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(service.purchaseMessage ?? 'Purchase successful!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ServiceProvider>();
    final plans = service.dataPlans.where((p) =>
        _selectedNetwork == 'All' ||
        p.network.toLowerCase() == _selectedNetwork.toLowerCase());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Network Selection
            const Text('Select Network', style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _networks.map((network) {
                  final selected = _selectedNetwork == network;
                  final color = _networkColors[network] ?? AppColors.primary;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedNetwork = network);
                        context.read<ServiceProvider>().fetchDataPlans(network: network);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: selected ? color : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected ? color : AppColors.line,
                            width: selected ? 0 : 1,
                          ),
                        ),
                        child: Text(
                          network,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: selected ? Colors.white : AppColors.textDark,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Plans
            const Text('Data Plans', style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 10),
            if (service.dataPlansLoading)
              const Center(child: CircularProgressIndicator())
            else
              ...plans.map((plan) => GestureDetector(
                    onTap: () => setState(() => _selectedPlanId = plan.id),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedPlanId == plan.id
                              ? AppColors.primary
                              : AppColors.line,
                          width: _selectedPlanId == plan.id ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan.planName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                if (plan.size != null || plan.validity != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '${plan.size ?? ''} • ${plan.validity ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₦${plan.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                              if (plan.oldPrice != null)
                                Text(
                                  '₦${plan.oldPrice!.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.muted,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),

            const SizedBox(height: 20),

            // Phone & PIN
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_android),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _pinController,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Transaction PIN',
                prefixIcon: Icon(Icons.lock_outline),
                counterText: '',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: service.purchasing ? null : _purchase,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
              child: service.purchasing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Purchase Data'),
            ),
          ],
        ),
    );
  }
}
