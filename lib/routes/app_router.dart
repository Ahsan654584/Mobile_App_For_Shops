import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../features/distributor/presentation/pages/distributor_dashboard_page.dart';
import '../features/customer/presentation/pages/customer_dashboard_page.dart';
import '../core/utils/constants.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Authentication routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Admin routes
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: 'admin_dashboard',
        builder: (context, state) => const AdminDashboardPage(),
        routes: [
          GoRoute(
            path: AppRoutes.products,
            name: 'admin_products',
            builder: (context, state) => const AdminProductsPage(),
            routes: [
              GoRoute(
                path: '/add',
                name: 'admin_add_product',
                builder: (context, state) => const AddProductPage(),
              ),
              GoRoute(
                path: '/edit/:id',
                name: 'admin_edit_product',
                builder: (context, state) {
                  final productId = state.pathParameters['id']!;
                  return EditProductPage(productId: productId);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.orders,
            name: 'admin_orders',
            builder: (context, state) => const AdminOrdersPage(),
          ),
          GoRoute(
            path: AppRoutes.customers,
            name: 'admin_customers',
            builder: (context, state) => const AdminCustomersPage(),
          ),
          GoRoute(
            path: AppRoutes.distributors,
            name: 'admin_distributors',
            builder: (context, state) => const AdminDistributorsPage(),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            name: 'admin_analytics',
            builder: (context, state) => const AdminAnalyticsPage(),
          ),
        ],
      ),

      // Distributor routes
      GoRoute(
        path: AppRoutes.distributorDashboard,
        name: 'distributor_dashboard',
        builder: (context, state) => const DistributorDashboardPage(),
        routes: [
          GoRoute(
            path: AppRoutes.products,
            name: 'distributor_products',
            builder: (context, state) => const DistributorProductsPage(),
          ),
          GoRoute(
            path: AppRoutes.orders,
            name: 'distributor_orders',
            builder: (context, state) => const DistributorOrdersPage(),
            routes: [
              GoRoute(
                path: '/:id',
                name: 'distributor_order_details',
                builder: (context, state) {
                  final orderId = state.pathParameters['id']!;
                  return DistributorOrderDetailsPage(orderId: orderId);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'distributor_profile',
            builder: (context, state) => const DistributorProfilePage(),
          ),
        ],
      ),

      // Customer routes
      GoRoute(
        path: AppRoutes.customerDashboard,
        name: 'customer_dashboard',
        builder: (context, state) => const CustomerDashboardPage(),
        routes: [
          GoRoute(
            path: AppRoutes.products,
            name: 'customer_products',
            builder: (context, state) => const CustomerProductsPage(),
          ),
          GoRoute(
            path: AppRoutes.orders,
            name: 'customer_orders',
            builder: (context, state) => const CustomerOrdersPage(),
            routes: [
              GoRoute(
                path: '/:id',
                name: 'customer_order_details',
                builder: (context, state) {
                  final orderId = state.pathParameters['id']!;
                  return CustomerOrderDetailsPage(orderId: orderId);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'customer_profile',
            builder: (context, state) => const CustomerProfilePage(),
          ),
        ],
      ),

      // Common routes
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => ErrorPage(error: state.error),

    // Redirect logic
    redirect: (context, state) {
      // Add authentication and role-based redirect logic here
      return null;
    },
  );
}

// Placeholder pages that will be implemented
class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Admin Products Page')),
    );
  }
}

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Add Product Page')),
    );
  }
}

class EditProductPage extends StatelessWidget {
  final String productId;

  const EditProductPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Edit Product Page: $productId')),
    );
  }
}

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Admin Orders Page')),
    );
  }
}

class AdminCustomersPage extends StatelessWidget {
  const AdminCustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Admin Customers Page')),
    );
  }
}

class AdminDistributorsPage extends StatelessWidget {
  const AdminDistributorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Admin Distributors Page')),
    );
  }
}

class AdminAnalyticsPage extends StatelessWidget {
  const AdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Admin Analytics Page')),
    );
  }
}

class DistributorProductsPage extends StatelessWidget {
  const DistributorProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Distributor Products Page')),
    );
  }
}

class DistributorOrdersPage extends StatelessWidget {
  const DistributorOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Distributor Orders Page')),
    );
  }
}

class DistributorOrderDetailsPage extends StatelessWidget {
  final String orderId;

  const DistributorOrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Distributor Order Details: $orderId')),
    );
  }
}

class DistributorProfilePage extends StatelessWidget {
  const DistributorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Distributor Profile Page')),
    );
  }
}

class CustomerProductsPage extends StatelessWidget {
  const CustomerProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Customer Products Page')),
    );
  }
}

class CustomerOrdersPage extends StatelessWidget {
  const CustomerOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Customer Orders Page')),
    );
  }
}

class CustomerOrderDetailsPage extends StatelessWidget {
  final String orderId;

  const CustomerOrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Customer Order Details: $orderId')),
    );
  }
}

class CustomerProfilePage extends StatelessWidget {
  const CustomerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Customer Profile Page')),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Profile Page')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Settings Page')),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Notifications Page')),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Search Page')),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('An error occurred'),
            const SizedBox(height: 16),
            Text(error?.toString() ?? 'Unknown error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.splash),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}