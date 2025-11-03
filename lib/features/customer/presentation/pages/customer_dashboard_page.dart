import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../routes/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class CustomerDashboardPage extends StatefulWidget {
  const CustomerDashboardPage({super.key});

  @override
  State<CustomerDashboardPage> createState() => _CustomerDashboardPageState();
}

class _CustomerDashboardPageState extends State<CustomerDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CustomerHomePage(),
    const CustomerProductsPage(),
    const CustomerOrdersPage(),
    const CustomerProfilePage(),
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
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
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

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state is AuthenticatedState
        ? (context.watch<AuthBloc>().state as AuthenticatedState).user
        : null;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar with Search
          SliverAppBar(
            title: Text(
              'Shop',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => context.push(AppRoutes.search),
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () => context.push(AppRoutes.notifications),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
            floating: true,
          ),

          // Welcome Banner
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
                      AppTheme.warningYellow,
                      AppTheme.successGreen,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${user?.name ?? 'Customer'}!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Gap(8.h),
                    Text(
                      'Discover amazing products and great deals!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                    Gap(16.h),
                    ElevatedButton(
                      onPressed: () => context.push('${AppRoutes.customerDashboard}${AppRoutes.products}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.warningYellow,
                      ),
                      child: const Text('Shop Now'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shop by Category',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Gap(16.h),
                  SizedBox(
                    height: 100.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryCard(
                          context,
                          'Electronics',
                          Icons.devices,
                          AppTheme.primaryBlue,
                        ),
                        Gap(12.w),
                        _buildCategoryCard(
                          context,
                          'Clothing',
                          Icons.checkroom,
                          Colors.purple,
                        ),
                        Gap(12.w),
                        _buildCategoryCard(
                          context,
                          'Food',
                          Icons.restaurant,
                          AppTheme.successGreen,
                        ),
                        Gap(12.w),
                        _buildCategoryCard(
                          context,
                          'Furniture',
                          Icons.chair,
                          Colors.brown,
                        ),
                        Gap(12.w),
                        _buildCategoryCard(
                          context,
                          'Books',
                          Icons.menu_book,
                          Colors.indigo,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Featured Products
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Products',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () => context.push('${AppRoutes.customerDashboard}${AppRoutes.products}'),
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  Gap(16.h),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.75,
                    children: [
                      _buildProductCard(
                        context,
                        'Laptop',
                        '\$899.99',
                        'High-performance laptop for work and gaming',
                        '4.5',
                        23,
                      ),
                      _buildProductCard(
                        context,
                        'Smartphone',
                        '\$699.99',
                        'Latest smartphone with amazing camera',
                        '4.3',
                        18,
                      ),
                      _buildProductCard(
                        context,
                        'Headphones',
                        '\$199.99',
                        'Premium noise-cancelling headphones',
                        '4.7',
                        31,
                      ),
                      _buildProductCard(
                        context,
                        'Smartwatch',
                        '\$299.99',
                        'Track your fitness and stay connected',
                        '4.4',
                        27,
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

  Widget _buildCategoryCard(
    BuildContext context,
    String name,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        // Navigate to category products
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 80.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24.w),
            Gap(8.h),
            Text(
              name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    String name,
    String price,
    String description,
    String rating,
    int reviews,
  ) {
    return InkWell(
      onTap: () {
        // Navigate to product details
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
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
            // Product Image Placeholder
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: Icon(
                  Icons.image,
                  size: 48.w,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(4.h),
                    Text(
                      price,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16.w,
                          color: Colors.amber,
                        ),
                        Gap(4.w),
                        Text(
                          rating,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Gap(4.w),
                        Text(
                          '($reviews)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
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
}

class CustomerProductsPage extends StatelessWidget {
  const CustomerProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Products Page - Coming Soon'),
      ),
    );
  }
}

class CustomerOrdersPage extends StatelessWidget {
  const CustomerOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Orders Page - Coming Soon'),
      ),
    );
  }
}

class CustomerProfilePage extends StatelessWidget {
  const CustomerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profile Page - Coming Soon'),
      ),
    );
  }
}