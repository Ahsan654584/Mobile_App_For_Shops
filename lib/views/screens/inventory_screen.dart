import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/data_provider.dart';
import '../../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_widget.dart';

/// Inventory management screen
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  void _loadInventory() {
    final dataProvider = context.read<DataProvider>();
    if (dataProvider.selectedShop != null) {
      dataProvider.loadItems(shopId: dataProvider.selectedShop!.id);
    }
  }

  void _showAddItemDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: 'Item Name',
                  controller: nameController,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Price',
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Quantity',
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Description (Optional)',
                  controller: descriptionController,
                  maxLines: 3,
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
                  await dataProvider.createItem(
                    id: const Uuid().v4(),
                    name: nameController.text,
                    price: double.parse(priceController.text),
                    quantity: int.parse(quantityController.text),
                    shopId: dataProvider.selectedShop!.id,
                    description: descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text,
                  );
                  if (mounted) Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item added successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ErrorDialog.show(
                      context,
                      title: 'Error',
                      message: 'Failed to add item: $e',
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
        title: const Text('Inventory'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, _) {
          if (dataProvider.selectedShop == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.store_mall_directory, size: 64),
                  const SizedBox(height: 16),
                  const Text('Please select a shop first'),
                  const SizedBox(height: 24),
                  CustomButton(
                    label: 'Go to Shops',
                    onPressed: () => Navigator.pushNamed(context, '/shops'),
                    width: 200,
                  ),
                ],
              ),
            );
          }

          if (dataProvider.isLoading) {
            return const LoadingWidget(message: 'Loading items...');
          }

          if (dataProvider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2,
                    size: 64,
                    color: AppConstants.textTertiaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text('No items yet'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: dataProvider.items.length,
            itemBuilder: (context, index) {
              final item = dataProvider.items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: Text(item.name),
                  subtitle: Text(
                    '${item.formattedPrice} • Stock: ${item.quantity}',
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () => _showEditItemDialog(item),
                      ),
                      PopupMenuItem(
                        child: const Text('Delete'),
                        onTap: () => _confirmDelete(item.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditItemDialog(Item item) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: item.name);
    final priceController = TextEditingController(text: item.price.toString());
    final quantityController = TextEditingController(text: item.quantity.toString());
    final descriptionController = TextEditingController(text: item.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: 'Item Name',
                  controller: nameController,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Price',
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Quantity',
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Description',
                  controller: descriptionController,
                  maxLines: 3,
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
                  final updatedItem = item.copyWith(
                    name: nameController.text,
                    price: double.parse(priceController.text),
                    quantity: int.parse(quantityController.text),
                    description: descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text,
                  );
                  await dataProvider.updateItem(updatedItem);
                  if (mounted) Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item updated successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ErrorDialog.show(
                      context,
                      title: 'Error',
                      message: 'Failed to update item: $e',
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

  void _confirmDelete(String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final dataProvider = context.read<DataProvider>();
              try {
                await dataProvider.deleteItem(itemId);
                if (mounted) Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item deleted')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ErrorDialog.show(
                    context,
                    title: 'Error',
                    message: 'Failed to delete item: $e',
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
