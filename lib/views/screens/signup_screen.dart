import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';

/// Sign up screen
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handle sign up
  void _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ErrorDialog.show(
        context,
        title: 'Terms Required',
        message: 'Please accept the terms and conditions to continue',
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    await authProvider.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      showSuccessSnackbar(
        context,
        'Account created successfully!',
      );
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else if (authProvider.errorMessage != null) {
      ErrorDialog.show(
        context,
        title: 'Sign Up Failed',
        message: authProvider.errorMessage ?? 'An error occurred',
      );
    }
  }

  /// Navigate back to login
  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateToLogin,
        ),
        iconTheme: const IconThemeData(
          color: AppConstants.textPrimaryColor,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Title
                Text(
                  'Create Account',
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: 8),
                Text(
                  'Join us to get started',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 32),
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
                  hint: 'Enter a strong password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.validatePassword,
                  prefixIcon: Icons.lock,
                ),
                const SizedBox(height: 8),
                Text(
                  'At least 8 characters with uppercase, lowercase, and numbers',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 24),
                // Confirm password field
                CustomTextField(
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (value) {
                    return Validators.validatePasswordConfirmation(
                      value,
                      _passwordController.text,
                    );
                  },
                  prefixIcon: Icons.lock,
                ),
                const SizedBox(height: 24),
                // Terms checkbox
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                    });
                  },
                  title: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodySmall,
                      children: [
                        const TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppConstants.primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 32),
                // Sign up button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return CustomButton(
                      label: 'Create Account',
                      onPressed: _handleSignup,
                      isLoading: authProvider.isLoading,
                      icon: Icons.person_add,
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextStyles.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: _navigateToLogin,
                      child: Text(
                        'Log In',
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
