import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../routes/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class DistributorDashboardPage extends StatefulWidget {
  const DistributorDashboardPage({super.key});

  @override
  State<DistributorDashboardPage> createState() => _DistributorDashboardPageState();
}

class _DistributorDashboardPageState extends State<DistributorDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DistributorHomePage(),
    const DistributorProductsPage(),
    const DistributorOrdersPage(),
    const DistributorProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state is AuthenticatedState
        ? (context.watch<AuthBloc>().state as AuthenticatedState).user
        : null;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class DistributorHomePage extends StatelessWidget {
  const DistributorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state is AuthenticatedState
        ? (context.watch<AuthBloc>().state as AuthenticatedState).user
        : null;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            title: Text(
              'Distributor Dashboard',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () => context.push(AppRoutes.notifications),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
          ),

          // Welcome Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryTeal,
                      AppTheme.primaryBlue,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${user?.name ?? 'Distributor'}!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Gap(8.h),
                    Text(
                      'Manage your inventory and orders efficiently.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Quick Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Active Orders',
                      '12',
                      Icons.receipt_long,
                      AppTheme.successGreen,
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Products',
                      '45',
                      Icons.inventory_2,
                      AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quick Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Gap(16.h),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 1.3,
                    children: [
                      _buildActionCard(
                        context,
                        'New Order',
                        'Create new customer order',
                        Icons.add_circle,
                        AppTheme.successGreen,
                        () => _showNewOrderDialog(context),
                      ),
                      _buildActionCard(
                        context,
                        'View Products',
                        'Browse available products',
                        Icons.shopping_bag,
                        AppTheme.primaryBlue,
                        () => context.push('${AppRoutes.distributorDashboard}${AppRoutes.products}'),
                      ),
                      _buildActionCard(
                        context,
                        'Order History',
                        'View past orders',
                        Icons.history,
                        AppTheme.warningYellow,
                        () => context.push('${AppRoutes.distributorDashboard}${AppRoutes.orders}'),
                      ),
                      _buildActionCard(
                        context,
                        'Profile',
                        'Manage your profile',
                        Icons.person,
                        AppTheme.primaryTeal,
                        () => context.push('${AppRoutes.distributorDashboard}${AppRoutes.profile}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32.w),
          Gap(8.h),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24.w),
            Gap(12.h),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Gap(4.h),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    AppHelpers.showConfirmationDialog(
      context,
      'Logout',
      'Are you sure you want to logout?',
      confirmText: 'Logout',
    ).then((confirmed) {
      if (confirmed) {
        context.read<AuthBloc>().add(LogoutEvent());
      }
    });
  }

  void _showNewOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Order'),
        content: const Text('Order creation feature will be implemented soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class DistributorProductsPage extends StatelessWidget {
  const DistributorProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Products Page - Coming Soon'),
      ),
    );
  }
}

class DistributorOrdersPage extends StatelessWidget {
  const DistributorOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Orders Page - Coming Soon'),
      ),
    );
  }
}

class DistributorProfilePage extends StatelessWidget {
  const DistributorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profile Page - Coming Soon'),
      ),
    );
  }
}