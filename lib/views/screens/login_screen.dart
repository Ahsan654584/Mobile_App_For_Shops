import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';

/// Login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle login
  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else if (authProvider.errorMessage != null) {
      ErrorDialog.show(
        context,
        title: 'Login Failed',
        message: authProvider.errorMessage ?? 'An error occurred',
      );
    }
  }

  /// Navigate to signup
  void _navigateToSignup() {
    Navigator.of(context).pushNamed(Routes.signup);
  }

  /// Request password reset
  void _requestPasswordReset() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ErrorDialog.show(
        context,
        title: 'Error',
        message: 'Please enter your email address',
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    authProvider.resetPassword(email).then((_) {
      if (mounted && authProvider.errorMessage == null) {
        showSuccessSnackbar(
          context,
          'Password reset email sent to $email',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                // Title
                Text(
                  'Welcome Back',
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: 8),
                Text(
                  'Log in to your account',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 48),
                // Email field
                CustomTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 24),
                // Password field
                CustomTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  prefixIcon: Icons.lock,
                ),
                const SizedBox(height: 12),
                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _requestPasswordReset,
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppConstants.primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                // Login button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return CustomButton(
                      label: 'Log In',
                      onPressed: _handleLogin,
                      isLoading: authProvider.isLoading,
                      icon: Icons.login,
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: _navigateToSignup,
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
