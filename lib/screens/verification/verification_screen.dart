import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_shell.dart';

class VerificationScreen extends StatelessWidget {
  final String type; // 'nin', 'bvn', 'phone'

  const VerificationScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isNin = type == 'nin';
    final title = isNin ? 'NIN Verification' : type == 'bvn' ? 'BVN Retrieval' : 'Phone Verification';
    final icon = isNin ? Icons.person_search : type == 'bvn' ? Icons.credit_card : Icons.phone;
    final color = isNin ? AppColors.danger : AppColors.primary;

    return Scaffold(
      appBar: AppBarWidget(title: title, showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: color),
            ),
            const SizedBox(height: 24),
            Text(
              'Verify your ${isNin ? "NIN" : type == "bvn" ? "BVN" : "Phone Number"}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your details below to verify',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 32),
            if (isNin) ...[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'NIN Number',
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
            ] else ...[
              TextFormField(
                decoration: InputDecoration(
                  labelText: type == 'bvn' ? 'BVN Number' : 'Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
