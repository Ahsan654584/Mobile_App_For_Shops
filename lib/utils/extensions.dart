import 'package:intl/intl.dart';

/// String extensions
extension StringExtension on String {
  /// Check if string is empty or null
  bool get isEmpty => trim().isEmpty;

  /// Check if string is not empty
  bool get isNotEmpty => trim().isNotEmpty;

  /// Capitalize first letter
  String get capitalized =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  /// Capitalize each word
  String get titleCase => split(' ')
      .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    try {
      Uri.parse(this);
      return startsWith('http://') || startsWith('https://');
    } catch (e) {
      return false;
    }
  }

  /// Truncate string to max length with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
}

/// DateTime extensions
extension DateTimeExtension on DateTime {
  /// Get formatted date string (yyyy-MM-dd)
  String get formattedDate => DateFormat('yyyy-MM-dd').format(this);

  /// Get formatted time string (HH:mm:ss)
  String get formattedTime => DateFormat('HH:mm:ss').format(this);

  /// Get formatted date and time string
  String get formattedDateTime => DateFormat('yyyy-MM-dd HH:mm:ss').format(this);

  /// Get relative time (e.g., "2 hours ago")
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return formattedDate;
    }
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Get date without time component
  DateTime get dateOnly => DateTime(year, month, day);

  /// Add days to date
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days from date
  DateTime subtractDays(int days) => subtract(Duration(days: days));
}

/// List extensions
extension ListExtension<T> on List<T> {
  /// Check if list is empty or null
  bool get isEmpty => length == 0;

  /// Check if list is not empty
  bool get isNotEmpty => length > 0;

  /// Get first element or null
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null
  T? get lastOrNull => isEmpty ? null : last;

  /// Remove duplicates
  List<T> get unique => toSet().toList();

  /// Chunk list into smaller lists
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}

/// Map extensions
extension MapExtension<K, V> on Map<K, V> {
  /// Get value with safe null check
  V? getOrNull(K key) => containsKey(key) ? this[key] : null;

  /// Convert map to list of values
  List<V> get values => this.values.toList();

  /// Convert map to list of keys
  List<K> get keys => this.keys.toList();
}

/// Number extensions
extension NumberExtension on num {
  /// Convert to currency string
  String toCurrency({String symbol = '\$'}) {
    return '$symbol${toStringAsFixed(2)}';
  }

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Get absolute value
  num get abs => (this < 0) ? -this : this;
}
