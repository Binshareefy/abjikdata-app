import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/service_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/transaction_tile.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _scrollController = ScrollController();
  String? _filterType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceProvider>().fetchTransactions();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final service = context.read<ServiceProvider>();
      if (!service.transactionsLoading && service.hasMore) {
        service.fetchTransactions(loadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ServiceProvider>();
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
          color: Colors.white,
          child: Row(
            children: [
              const Expanded(
                child: Text('Transactions',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3D3E45))),
              ),
              PopupMenuButton<String?>(
                icon: const Icon(Icons.filter_list, color: Color(0xFF858796)),
                onSelected: (type) {
                  setState(() => _filterType = type);
                  service.fetchTransactions();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: null, child: Text('All')),
                  const PopupMenuItem(value: 'data', child: Text('Data')),
                  const PopupMenuItem(value: 'airtime', child: Text('Airtime')),
                  const PopupMenuItem(value: 'electricity', child: Text('Electricity')),
                  const PopupMenuItem(value: 'cable', child: Text('Cable TV')),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
        onRefresh: () => service.fetchTransactions(),
        child: service.transactionsLoading && service.transactions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : service.transactions.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 200),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.receipt_long, size: 64, color: AppColors.muted),
                            SizedBox(height: 16),
                            Text('No transactions yet',
                                style: TextStyle(color: AppColors.muted, fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount:
                        service.transactions.length + (service.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= service.transactions.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TransactionTile(
                            transaction: service.transactions[index]),
                      );
                    },
                  ),
        ),
      ),
      ],
    );
  }
}
