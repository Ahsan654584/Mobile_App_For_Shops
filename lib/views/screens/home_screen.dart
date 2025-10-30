import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/error_dialog.dart';

/// Home/Dashboard screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Handle logout
  void _handleLogout() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();

    if (!mounted) return;

    if (!authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }

  /// Navigate to settings
  void _navigateToSettings() {
    Navigator.of(context).pushNamed(Routes.settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        elevation: 0,
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: AppTextStyles.heading3.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          authProvider.userName,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authProvider.userEmail,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              // Connectivity status
              Consumer<ConnectivityProvider>(
                builder: (context, connectivityProvider, _) {
                  return Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: connectivityProvider.isOnline
                          ? AppConstants.successColor.withOpacity(0.1)
                          : AppConstants.warningColor.withOpacity(0.1),
                      border: Border.all(
                        color: connectivityProvider.isOnline
                            ? AppConstants.successColor
                            : AppConstants.warningColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          connectivityProvider.isOnline
                              ? Icons.cloud_done
                              : Icons.cloud_off,
                          color: connectivityProvider.isOnline
                              ? AppConstants.successColor
                              : AppConstants.warningColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            connectivityProvider.statusMessage,
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              // Features section
              Text(
                'Quick Actions',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 16),
              // Feature cards (placeholder)
              _buildFeatureCard(
                icon: Icons.store,
                title: 'My Shops',
                description: 'Manage your shops',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Coming Soon'),
                      content: const Text('Shop management features are coming soon.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                icon: Icons.inventory_2,
                title: 'Inventory',
                description: 'Manage inventory and stock',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Coming Soon'),
                      content: const Text('Inventory management features are coming soon.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                icon: Icons.receipt,
                title: 'Orders',
                description: 'View and manage orders',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Coming Soon'),
                      content: const Text('Order management features are coming soon.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),
              // Logout button
              CustomButton(
                label: 'Log Out',
                onPressed: _handleLogout,
                backgroundColor: AppConstants.errorColor,
                icon: Icons.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build feature card widget
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          border: Border.all(
            color: AppConstants.backgroundColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Icon(
                icon,
                color: AppConstants.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppConstants.textTertiaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
