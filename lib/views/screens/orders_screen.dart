import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../providers/data_provider.dart';
import '../../utils/constants.dart';
import '../widgets/loading_widget.dart';

/// Orders management screen
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    final dataProvider = context.read<DataProvider>();
    if (dataProvider.selectedShop != null) {
      dataProvider.loadOrders(shopId: dataProvider.selectedShop!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, _) {
          if (dataProvider.isLoading) {
            return const LoadingWidget(message: 'Loading orders...');
          }

          if (dataProvider.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt,
                    size: 64,
                    color: AppConstants.textTertiaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text('No orders yet'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: dataProvider.orders.length,
            itemBuilder: (context, index) {
              final order = dataProvider.orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ListTile(
                  leading: const Icon(Icons.receipt),
                  title: Text('Order #${order.id.substring(0, 8)}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Items: ${order.itemCount}'),
                      Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          order.statusText,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('View'),
                        onTap: () => _showOrderDetails(order),
                      ),
                      if (order.status != OrderStatus.cancelled)
                        PopupMenuItem(
                          child: const Text('Update Status'),
                          onTap: () => _showStatusMenu(order),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order #${order.id.substring(0, 8)}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status: ${order.statusText}'),
              const SizedBox(height: 12),
              Text('Items:'),
              ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${item.itemName} (${item.quantity}x \$${item.price.toStringAsFixed(2)})',
                    ),
                  )),
              const SizedBox(height: 16),
              Text(
                'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (order.customerName != null) ...[
                const SizedBox(height: 16),
                Text('Customer: ${order.customerName}'),
              ],
              if (order.customerEmail != null)
                Text('Email: ${order.customerEmail}'),
              if (order.customerPhone != null)
                Text('Phone: ${order.customerPhone}'),
              if (order.deliveryAddress != null) ...[
                const SizedBox(height: 12),
                Text('Delivery: ${order.deliveryAddress}'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showStatusMenu(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...OrderStatus.values
                .where((status) => status != OrderStatus.cancelled)
                .map((status) => ListTile(
                      title: Text(status.name.toUpperCase()),
                      onTap: () async {
                        final dataProvider = context.read<DataProvider>();
                        await dataProvider.updateOrderStatus(order.id, status);
                        if (mounted) Navigator.pop(context);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order status updated'),
                            ),
                          );
                        }
                      },
                    )),
          ],
        ),
      ),
    );
  }
}
