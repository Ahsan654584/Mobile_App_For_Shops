import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../routes/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/admin_dashboard_card.dart';
import '../widgets/admin_stats_widget.dart';
import '../widgets/admin_recent_orders_widget.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppHelpers;
    final user = context.watch<AuthBloc>().state is AuthenticatedState
        ? (context.watch<AuthBloc>().state as AuthenticatedState).user
        : null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120.h,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Admin Dashboard',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              titlePadding: EdgeInsets.only(
                left: 16.w,
                bottom: 16.h,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () => context.push(AppRoutes.notifications),
              ),
              PopupMenuButton<String>(
                icon: CircleAvatar(
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Text(user?.initials ?? 'A')
                      : null,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'profile':
                      context.push(AppRoutes.profile);
                      break;
                    case 'settings':
                      context.push(AppRoutes.settings);
                      break;
                    case 'logout':
                      _showLogoutDialog();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 8),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 8),
                        Text('Settings'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Dashboard Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Message
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${user?.name ?? 'Admin'}!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Gap(8.h),
                        Text(
                          'Here\'s what\'s happening with your shop today.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),

                  Gap(24.h),

                  // Stats Overview
                  const AdminStatsWidget()
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),

                  Gap(24.h),

                  // Quick Actions
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

                  Gap(16.h),

                  // Action Cards Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 1.2,
                    children: [
                      AdminDashboardCard(
                        title: 'Add Product',
                        description: 'Add new products to inventory',
                        icon: Icons.add_shopping_cart,
                        color: AppTheme.successGreen,
                        onTap: () => context.push('${AppRoutes.adminDashboard}${AppRoutes.products}${AppRoutes.add}'),
                      ),
                      AdminDashboardCard(
                        title: 'Manage Orders',
                        description: 'View and manage customer orders',
                        icon: Icons.receipt_long,
                        color: AppTheme.primaryBlue,
                        onTap: () => context.push('${AppRoutes.adminDashboard}${AppRoutes.orders}'),
                      ),
                      AdminDashboardCard(
                        title: 'Customers',
                        description: 'View customer information',
                        icon: Icons.people,
                        color: AppTheme.warningYellow,
                        onTap: () => context.push('${AppRoutes.adminDashboard}${AppRoutes.customers}'),
                      ),
                      AdminDashboardCard(
                        title: 'Distributors',
                        description: 'Manage distributor accounts',
                        icon: Icons.local_shipping,
                        color: AppTheme.primaryTeal,
                        onTap: () => context.push('${AppRoutes.adminDashboard}${AppRoutes.distributors}'),
                      ),
                      AdminDashboardCard(
                        title: 'Analytics',
                        description: 'View business analytics',
                        icon: Icons.analytics,
                        color: Colors.purple,
                        onTap: () => context.push('${AppRoutes.adminDashboard}${AppRoutes.analytics}'),
                      ),
                      AdminDashboardCard(
                        title: 'Settings',
                        description: 'App and system settings',
                        icon: Icons.settings,
                        color: Colors.grey,
                        onTap: () => context.push(AppRoutes.settings),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms),

                  Gap(24.h),

                  // Recent Orders
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Orders',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () => context.push('${AppRoutes.adminDashboard}${AppRoutes.orders}'),
                        child: const Text('View All'),
                      ),
                    ],
                  ).animate().fadeIn(delay: 800.ms, duration: 600.ms),

                  Gap(16.h),

                  const AdminRecentOrdersWidget()
                      .animate()
                      .fadeIn(delay: 1000.ms, duration: 600.ms),

                  Gap(40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
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
}