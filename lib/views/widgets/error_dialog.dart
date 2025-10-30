import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Error dialog widget
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ErrorDialog({
    Key? key,
    required this.title,
    required this.message,
    this.onRetry,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.error_outline,
        color: AppConstants.errorColor,
        size: 32,
      ),
      title: Text(
        title,
        style: AppTextStyles.heading3,
      ),
      content: Text(
        message,
        style: AppTextStyles.bodyMedium,
      ),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry?.call();
            },
            child: const Text('Retry'),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDismiss?.call();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  /// Show error dialog
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        onRetry: onRetry,
        onDismiss: onDismiss,
      ),
    );
  }
}

/// Show snackbar error
void showErrorSnackbar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppConstants.errorColor,
      duration: duration,
    ),
  );
}

/// Show success snackbar
void showSuccessSnackbar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppConstants.successColor,
      duration: duration,
    ),
  );
}
