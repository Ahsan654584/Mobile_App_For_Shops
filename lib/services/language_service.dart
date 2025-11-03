import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/error/exceptions.dart';
import '../core/utils/constants.dart';

@singleton
class LanguageService {
  static const String _languageKey = AppConstants.languageKey;

  // Supported languages
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('ur', 'PK'), // Urdu
  ];

  // Get language display names
  static Map<String, String> get languageNames => {
        'en': 'English',
        'ur': 'اردو',
      };

  // Get language native names
  static Map<String, String> get nativeLanguageNames => {
        'en': 'English',
        'ur': 'اردو',
      };

  // Get language flags (emoji representation)
  static Map<String, String> get languageFlags => {
        'en': '🇺🇸',
        'ur': '🇵🇰',
      };

  // Get text direction for language
  static TextDirection getTextDirection(String languageCode) {
    return languageCode == 'ur' ? TextDirection.rtl : TextDirection.ltr;
  }

  // Check if language is RTL
  static bool isRTL(String languageCode) {
    return languageCode == 'ur';
  }

  // Check if current locale is RTL
  static bool isCurrentLocaleRTL(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ur';
  }

  // Get text direction for current locale
  static TextDirection getCurrentTextDirection(BuildContext context) {
    return isCurrentLocaleRTL(context) ? TextDirection.rtl : TextDirection.ltr;
  }

  // Save language preference locally
  Future<void> saveLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!supportedLanguages.contains(languageCode)) {
        throw ValidationException.custom('Unsupported language code: $languageCode');
      }
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      throw CacheException.writeError(_languageKey);
    }
  }

  // Get saved language
  Future<String> getLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_languageKey) ?? 'en';
    } catch (e) {
      return 'en'; // Default to English
    }
  }

  // Get current language code synchronously (if available)
  String? getCurrentLanguage() {
    try {
      final prefs = SharedPreferences.getInstance();
      return prefs.then((prefs) => prefs.getString(_languageKey) ?? 'en').asStream().first;
    } catch (e) {
      return 'en';
    }
  }

  // Change app language and restart
  Future<void> changeLanguage(BuildContext context, String languageCode) async {
    try {
      await saveLanguage(languageCode);

      // Find the app state and restart
      final app = context.findAncestorStateOfType<_MyAppState>();
      app?.restart();
    } catch (e) {
      throw CacheException.writeError(_languageKey);
    }
  }

  // Get locale for language code
  static Locale getLocale(String languageCode) {
    final locale = supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => const Locale('en', 'US'),
    );
    return locale;
  }

  // Get language code from locale
  static String getLanguageCode(Locale locale) {
    return locale.languageCode;
  }

  // Check if language is supported
  static bool isLanguageSupported(String languageCode) {
    return supportedLanguages.contains(languageCode);
  }

  // Get supported language codes
  static List<String> get supportedLanguages =>
      supportedLocales.map((locale) => locale.languageCode).toList();

  // Get supported locales
  static List<Locale> get supportedLocaleList => supportedLocales;

  // Get default locale
  static Locale get defaultLocale => const Locale('en', 'US');

  // Get fallback locale
  static Locale get fallbackLocale => const Locale('en', 'US');

  // Resolve locale based on system preferences and saved preference
  static Future<Locale> resolveLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);

      if (savedLanguage != null && isLanguageSupported(savedLanguage)) {
        return getLocale(savedLanguage);
      }

      // Fallback to system locale if supported
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      if (isLanguageSupported(systemLocale.languageCode)) {
        return systemLocale;
      }

      // Default to English
      return defaultLocale;
    } catch (e) {
      return defaultLocale;
    }
  }

  // Get language display information
  static LanguageInfo getLanguageInfo(String languageCode) {
    return LanguageInfo(
      code: languageCode,
      name: languageNames[languageCode] ?? 'Unknown',
      nativeName: nativeLanguageNames[languageCode] ?? 'Unknown',
      flag: languageFlags[languageCode] ?? '🏳️',
      isRTL: isRTL(languageCode),
      locale: getLocale(languageCode),
    );
  }

  // Get all supported language information
  static List<LanguageInfo> getSupportedLanguagesInfo() {
    return supportedLanguages.map((code) => getLanguageInfo(code)).toList();
  }

  // Format text for RTL/LTR properly
  static String formatText(String text, BuildContext context) {
    final isRTL = isCurrentLocaleRTL(context);
    if (isRTL) {
      // For RTL languages, ensure proper formatting
      return text.contains('(') && text.contains(')')
          ? text.replaceAll('(', '،').replaceAll(')', '،')
          : text;
    }
    return text;
  }

  // Get alignment for text direction
  static TextAlign getTextAlign(BuildContext context, {TextAlign? defaultAlign}) {
    final isRTL = isCurrentLocaleRTL(context);
    if (defaultAlign != null) {
      return defaultAlign;
    }
    return isRTL ? TextAlign.right : TextAlign.left;
  }

  // Get alignment for text direction (start/end)
  static Alignment getAlignment(BuildContext context, {
    Alignment? defaultAlign,
    bool reverse = false,
  }) {
    final isRTL = isCurrentLocaleRTL(context);
    if (defaultAlign != null) {
      return defaultAlign;
    }

    if (reverse) {
      return isRTL ? Alignment.centerLeft : Alignment.centerRight;
    }
    return isRTL ? Alignment.centerRight : Alignment.centerLeft;
  }

  // Get padding for text direction
  static EdgeInsets getDirectionalPadding(BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
    double start = 0,
    double end = 0,
  }) {
    final isRTL = isCurrentLocaleRTL(context);
    return EdgeInsets.only(
      top: vertical,
      bottom: vertical,
      left: isRTL ? end : (start > 0 ? start : horizontal),
      right: isRTL ? (start > 0 ? start : horizontal) : end,
    );
  }

  // Get border radius for text direction
  static BorderRadius getDirectionalBorderRadius(BuildContext context, {
    double all = 0,
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    final isRTL = isCurrentLocaleRTL(context);
    return BorderRadius.only(
      topLeft: topLeft > 0 ? topLeft : (isRTL ? topRight : all),
      topRight: topRight > 0 ? topRight : (isRTL ? topLeft : all),
      bottomLeft: bottomLeft > 0 ? bottomLeft : (isRTL ? bottomRight : all),
      bottomRight: bottomRight > 0 ? bottomRight : (isRTL ? bottomLeft : all),
    );
  }

  // Validate language code
  static bool isValidLanguageCode(String code) {
    return code.length == 2 && RegExp(r'^[a-z]{2}$').hasMatch(code);
  }

  // Get language family
  static String getLanguageFamily(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'Indo-European';
      case 'ur':
        return 'Indo-Aryan';
      default:
        return 'Unknown';
    }
  }

  // Get language writing system
  static String getWritingSystem(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'Latin';
      case 'ur':
        return 'Arabic-Persian';
      default:
        return 'Unknown';
    }
  }

  // Check if language requires special font handling
  static bool requiresSpecialFont(String languageCode) {
    return languageCode == 'ur'; // Urdu requires special font handling
  }

  // Get recommended font family for language
  static String? getRecommendedFontFamily(String languageCode) {
    switch (languageCode) {
      case 'ur':
        return 'Noto Nastaliq Urdu';
      default:
        return null; // Use system default
    }
  }

  // Format number for locale
  static String formatNumber(dynamic number, BuildContext context) {
    try {
      final locale = Localizations.localeOf(context);
      return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match.group(1)},',
      );
    } catch (e) {
      return number.toString();
    }
  }

  // Format currency for locale
  static String formatCurrency(
    double amount,
    BuildContext context, {
    String? symbol,
    int decimalDigits = 2,
  }) {
    try {
      final formattedAmount = amount.toStringAsFixed(decimalDigits);
      final locale = Localizations.localeOf(context);

      // Add comma separators for thousands
      final parts = formattedAmount.split('.');
      parts[0] = parts[0].replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match.group(1)},',
      );

      final currencySymbol = symbol ?? (locale.languageCode == 'ur' ? 'Rs' : '\$');
      final isRTL = isCurrentLocaleRTL(context);

      if (isRTL) {
        return '$formattedAmount $currencySymbol';
      } else {
        return '$currencySymbol$formattedAmount';
      }
    } catch (e) {
      return amount.toString();
    }
  }

  // Format date for locale
  static String formatDate(
    DateTime date,
    BuildContext context, {
    String? pattern,
  }) {
    try {
      final locale = Localizations.localeOf(context);
      final isRTL = isCurrentLocaleRTL(context);

      if (pattern != null) {
        // Custom pattern formatting would require intl package
        return date.toString().split(' ')[0]; // Simple fallback
      }

      // Basic date formatting based on locale
      switch (locale.languageCode) {
        case 'ur':
          return '${date.day}/${date.month}/${date.year}';
        default:
          return '${date.month}/${date.day}/${date.year}';
      }
    } catch (e) {
      return date.toString().split(' ')[0];
    }
  }
}

// Language information class
class LanguageInfo {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final bool isRTL;
  final Locale locale;

  const LanguageInfo({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.isRTL,
    required this.locale,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LanguageInfo && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() {
    return 'LanguageInfo(code: $code, name: $name, nativeName: $nativeName)';
  }
}

// Extension method for app restart functionality
extension on State {
  void restart() {
    // This would be implemented in the main app widget
    // For now, this is a placeholder
  }
}

// Placeholder for app state
class _MyAppState extends State {
  void restart() {
    // Implementation would go here
  }
}