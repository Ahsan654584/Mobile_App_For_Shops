import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/error_dialog.dart';

/// User profile screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.currentUser == null) {
            return const Center(
              child: Text('No user logged in'),
            );
          }

          final user = authProvider.currentUser!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                // Profile header
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.displayName,
                        style: AppTextStyles.heading3.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Profile information
                _buildInfoSection(
                  label: 'Email',
                  value: user.email,
                  icon: Icons.email,
                ),
                const SizedBox(height: 16),
                _buildInfoSection(
                  label: 'Email Verified',
                  value: user.isEmailVerified ? 'Yes' : 'No',
                  icon: Icons.verified,
                ),
                if (user.phoneNumber != null) ...[
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    label: 'Phone',
                    value: user.phoneNumber!,
                    icon: Icons.phone,
                  ),
                ],
                const SizedBox(height: 32),
                // Member since
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppConstants.backgroundColor,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppConstants.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Member Since',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppConstants.textSecondaryColor,
                            ),
                          ),
                          Text(
                            user.formattedCreatedAt,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Action buttons
                CustomButton(
                  label: 'Change Password',
                  onPressed: () => _showChangePasswordDialog(),
                  backgroundColor: AppConstants.accentColor,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  label: 'Log Out',
                  onPressed: () => _handleLogout(),
                  backgroundColor: AppConstants.errorColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppConstants.backgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: AppConstants.textTertiaryColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppConstants.textSecondaryColor,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your email address and we will send you a password reset link.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.resetPassword(emailController.text);

              if (mounted) Navigator.pop(context);
              if (mounted && authProvider.errorMessage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset email sent!'),
                  ),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();

              if (mounted) {
                Navigator.of(context).pushReplacementNamed(Routes.login);
              }
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
