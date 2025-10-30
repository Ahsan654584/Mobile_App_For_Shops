import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/shop.dart';
import '../../providers/auth_provider.dart';
import '../../providers/data_provider.dart';
import '../../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_widget.dart';

/// Shops management screen
class ShopsScreen extends StatefulWidget {
  const ShopsScreen({Key? key}) : super(key: key);

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  void _loadShops() {
    final authProvider = context.read<AuthProvider>();
    final dataProvider = context.read<DataProvider>();
    if (authProvider.currentUser != null) {
      dataProvider.loadShops(userId: authProvider.currentUser!.id);
    }
  }

  void _showAddShopDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Shop'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: 'Shop Name',
                  controller: nameController,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Address',
                  controller: addressController,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'City',
                  controller: cityController,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final authProvider = context.read<AuthProvider>();
                final dataProvider = context.read<DataProvider>();

                try {
                  await dataProvider.createShop(
                    id: const Uuid().v4(),
                    name: nameController.text,
                    ownerId: authProvider.currentUser!.id,
                    address: addressController.text,
                    city: cityController.text.isEmpty ? null : cityController.text,
                  );
                  if (mounted) Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Shop added successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ErrorDialog.show(
                      context,
                      title: 'Error',
                      message: 'Failed to add shop: $e',
                    );
                  }
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shops'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, _) {
          if (dataProvider.isLoading) {
            return const LoadingWidget(message: 'Loading shops...');
          }

          if (dataProvider.shops.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store,
                    size: 64,
                    color: AppConstants.textTertiaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No shops yet',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first shop to get started',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: dataProvider.shops.length,
            itemBuilder: (context, index) {
              final shop = dataProvider.shops[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ListTile(
                  leading: const Icon(Icons.store),
                  title: Text(shop.name),
                  subtitle: Text(shop.address),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () => _showEditShopDialog(shop),
                      ),
                      PopupMenuItem(
                        child: const Text('Delete'),
                        onTap: () => _confirmDelete(shop.id),
                      ),
                    ],
                  ),
                  onTap: () {
                    dataProvider.setSelectedShop(shop);
                    Navigator.pushNamed(context, '/shop-detail');
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddShopDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditShopDialog(Shop shop) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: shop.name);
    final addressController = TextEditingController(text: shop.address);
    final cityController = TextEditingController(text: shop.city ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Shop'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: 'Shop Name',
                  controller: nameController,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Address',
                  controller: addressController,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'City',
                  controller: cityController,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final dataProvider = context.read<DataProvider>();

                try {
                  final updatedShop = shop.copyWith(
                    name: nameController.text,
                    address: addressController.text,
                    city: cityController.text.isEmpty ? null : cityController.text,
                  );
                  await dataProvider.updateShop(updatedShop);
                  if (mounted) Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Shop updated successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ErrorDialog.show(
                      context,
                      title: 'Error',
                      message: 'Failed to update shop: $e',
                    );
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String shopId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Shop'),
        content: const Text('Are you sure you want to delete this shop?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final dataProvider = context.read<DataProvider>();
              try {
                await dataProvider.deleteShop(shopId);
                if (mounted) Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Shop deleted')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ErrorDialog.show(
                    context,
                    title: 'Error',
                    message: 'Failed to delete shop: $e',
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
