import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_widget.dart';

/// Shop detail screen
class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({Key? key}) : super(key: key);

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadShopDetails();
  }

  void _loadShopDetails() {
    final dataProvider = context.read<DataProvider>();
    if (dataProvider.selectedShop != null) {
      dataProvider.loadItems(shopId: dataProvider.selectedShop!.id);
      dataProvider.loadOrders(shopId: dataProvider.selectedShop!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Details'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, _) {
          final shop = dataProvider.selectedShop;

          if (shop == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64),
                  const SizedBox(height: 16),
                  const Text('Shop not found'),
                  const SizedBox(height: 24),
                  CustomButton(
                    label: 'Go Back',
                    onPressed: () => Navigator.pop(context),
                    width: 200,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shop header
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.store,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shop.name,
                                  style: AppTextStyles.heading3.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  shop.fullAddress,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Statistics section
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        label: 'Items',
                        value: dataProvider.items.length.toString(),
                        icon: Icons.inventory_2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        label: 'Orders',
                        value: dataProvider.orders.length.toString(),
                        icon: Icons.receipt,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Shop information
                Text(
                  'Shop Information',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Address', shop.address),
                if (shop.city != null) _buildInfoRow('City', shop.city!),
                if (shop.state != null) _buildInfoRow('State', shop.state!),
                if (shop.postalCode != null)
                  _buildInfoRow('Postal Code', shop.postalCode!),
                if (shop.phone != null) _buildInfoRow('Phone', shop.phone!),
                if (shop.email != null) _buildInfoRow('Email', shop.email!),
                if (shop.website != null)
                  _buildInfoRow('Website', shop.website!),
                const SizedBox(height: 32),
                // Quick actions
                Text(
                  'Quick Actions',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: 'View Inventory',
                  onPressed: () => Navigator.pushNamed(context, '/inventory'),
                  icon: Icons.inventory_2,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  label: 'View Orders',
                  onPressed: () => Navigator.pushNamed(context, '/orders'),
                  icon: Icons.receipt,
                  backgroundColor: AppConstants.accentColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: AppConstants.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppConstants.primaryColor,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading3.copyWith(
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppConstants.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppConstants.textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
