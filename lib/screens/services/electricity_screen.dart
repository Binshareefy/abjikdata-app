import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/service_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_shell.dart';

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({super.key});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  final _meterController = TextEditingController();
  final _amountController = TextEditingController();
  final _pinController = TextEditingController();
  String? _selectedProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceProvider>().fetchElectricityProviders();
    });
  }

  @override
  void dispose() {
    _meterController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ServiceProvider>();
    return Scaffold(
      appBar: const AppBarWidget(title: 'Pay Electricity', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Provider',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const SizedBox(height: 10),
            if (service.electricityLoading)
              const Center(child: CircularProgressIndicator())
            else
              ...service.electricityProviders.map((provider) {
                final selected = _selectedProvider == provider.id;
                return GestureDetector(
                  onTap: () => setState(() => _selectedProvider = provider.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.line,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.bolt, color: AppColors.warning),
                        ),
                        const SizedBox(width: 14),
                        Text(provider.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 20),
            TextFormField(
              controller: _meterController,
              decoration: const InputDecoration(
                labelText: 'Meter Number',
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.money),
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
              onPressed: null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
              child: const Text('Pay Electricity Bill'),
            ),
          ],
        ),
      ),
    );
  }
}
