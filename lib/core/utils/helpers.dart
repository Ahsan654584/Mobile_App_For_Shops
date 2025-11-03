import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AppHelpers {
  static final Uuid _uuid = const Uuid();

  // Generate unique ID
  static String generateId() {
    return _uuid.v4();
  }

  // Format currency
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  // Format date
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(date);
  }

  // Format date with time
  static String formatDateTime(DateTime dateTime, {String format = 'MMM dd, yyyy - hh:mm a'}) {
    return DateFormat(format).format(dateTime);
  }

  // Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  // Validate phone number
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone);
  }

  // Validate password strength (0-4 scale)
  static int getPasswordStrength(String password) {
    int score = 0;

    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    return score;
  }

  // Get password strength text
  static String getPasswordStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
      case 3:
        return 'Medium';
      case 4:
      case 5:
        return 'Strong';
      default:
        return 'Unknown';
    }
  }

  // Get password strength color
  static Color getPasswordStrengthColor(int strength, BuildContext context) {
    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
      case 3:
        return Colors.orange;
      case 4:
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Capitalize first letter of each word
  static String capitalize(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
  }

  // Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Get status color
  static Color getStatusColor(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_transit':
      case 'in-progress':
        return Colors.blue;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'cancelled':
      case 'failed':
        return Colors.red;
      case 'low_stock':
        return Colors.orange;
      case 'out_of_stock':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get status text
  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'in_transit':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      case 'completed':
        return 'Completed';
      case 'failed':
        return 'Failed';
      case 'low_stock':
        return 'Low Stock';
      case 'out_of_stock':
        return 'Out of Stock';
      default:
        return capitalize(status.replaceAll('_', ' '));
    }
  }

  // Show snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.inverseSurface,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  // Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
    );
  }

  // Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.red,
    );
  }

  // Show loading dialog
  static void showLoadingDialog(BuildContext context, {String message = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            SizedBox(width: 16.w),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  // Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Show confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context,
    String title,
    String message, {
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Show error dialog
  static void showErrorDialog(
    BuildContext context,
    String title,
    String message, {
    String buttonText = 'OK',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  // Debounce function
  static Function debounce(Function function, Duration delay) {
    Timer? timer;
    return () {
      if (timer != null) timer!.cancel();
      timer = Timer(delay, () => function());
    };
  }

  // Scroll to top of list
  static void scrollToTop(ScrollController controller) {
    if (controller.hasClients) {
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Check if device is tablet
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  // Get responsive value
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200 && desktop != null) return desktop;
    if (width >= 800 && tablet != null) return tablet;
    return mobile;
  }

  // Generate random color
  static Color getRandomColor() {
    return Color((Math.random() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);
  }

  // Lighten color
  static Color lightenColor(Color color, [double amount = 0.3]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  // Darken color
  static Color darkenColor(Color color, [double amount = 0.3]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}

// Math extension for random color generation
extension Math on double {
  static double random() {
    return DateTime.now().millisecondsSinceEpoch % 1000 / 1000;
  }
}