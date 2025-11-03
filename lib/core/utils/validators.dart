import 'package:flutter/material.dart';

class AppValidators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{6,}$').hasMatch(value)) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (value.length > 50) {
      return 'Name cannot be more than 50 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Product name validation
  static String? validateProductName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product name is required';
    }
    if (value.length < 2) {
      return 'Product name must be at least 2 characters long';
    }
    if (value.length > 100) {
      return 'Product name cannot be more than 100 characters';
    }
    return null;
  }

  // Product price validation
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid price';
    }
    if (price <= 0) {
      return 'Price must be greater than 0';
    }
    if (price > 999999) {
      return 'Price cannot be more than 999,999';
    }
    return null;
  }

  // Product quantity validation
  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid quantity';
    }
    if (quantity < 0) {
      return 'Quantity cannot be negative';
    }
    if (quantity > 99999) {
      return 'Quantity cannot be more than 99,999';
    }
    return null;
  }

  // Category validation
  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Category is required';
    }
    return null;
  }

  // Description validation
  static String? validateDescription(String? value) {
    if (value != null && value.length > 500) {
      return 'Description cannot be more than 500 characters';
    }
    return null;
  }

  // Address validation
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.length < 10) {
      return 'Please enter a complete address';
    }
    if (value.length > 200) {
      return 'Address cannot be more than 200 characters';
    }
    return null;
  }

  // ZIP code validation
  static String? validateZipCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ZIP code is required';
    }
    if (!RegExp(r'^[0-9]{5,10}$').hasMatch(value)) {
      return 'Please enter a valid ZIP code';
    }
    return null;
  }

  // Search validation
  static String? validateSearch(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.length < 2) {
        return 'Search term must be at least 2 characters';
      }
      if (value.length > 100) {
        return 'Search term cannot be more than 100 characters';
      }
    }
    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^https?:\/\/.+\..+').hasMatch(value)) {
        return 'Please enter a valid URL';
      }
    }
    return null;
  }

  // Percentage validation
  static String? validatePercentage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Percentage is required';
    }
    final percentage = double.tryParse(value);
    if (percentage == null) {
      return 'Please enter a valid percentage';
    }
    if (percentage < 0) {
      return 'Percentage cannot be negative';
    }
    if (percentage > 100) {
      return 'Percentage cannot be more than 100';
    }
    return null;
  }

  // Discount validation
  static String? validateDiscount(String? value) {
    if (value != null && value.isNotEmpty) {
      final discount = double.tryParse(value);
      if (discount == null) {
        return 'Please enter a valid discount amount';
      }
      if (discount < 0) {
        return 'Discount cannot be negative';
      }
      if (discount > 100) {
        return 'Discount cannot be more than 100%';
      }
    }
    return null;
  }

  // Stock quantity validation
  static String? validateStockQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Stock quantity is required';
    }
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid quantity';
    }
    if (quantity < 0) {
      return 'Stock quantity cannot be negative';
    }
    return null;
  }

  // Minimum stock validation
  static String? validateMinStock(String? value) {
    if (value != null && value.isNotEmpty) {
      final minStock = int.tryParse(value);
      if (minStock == null) {
        return 'Please enter a valid minimum stock';
      }
      if (minStock < 0) {
        return 'Minimum stock cannot be negative';
      }
    }
    return null;
  }

  // Compose multiple validators
  static String? composeValidators(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }

  // Custom validator with regex
  static String? validateWithRegex(
    String? value,
    String regex,
    String errorMessage,
  ) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(regex).hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  // Length validator
  static String? validateLength(
    String? value,
    int minLength,
    int maxLength, {
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    if (value.length < minLength) {
      return fieldName != null
          ? '$fieldName must be at least $minLength characters'
          : 'Must be at least $minLength characters';
    }
    if (value.length > maxLength) {
      return fieldName != null
          ? '$fieldName cannot be more than $maxLength characters'
          : 'Cannot be more than $maxLength characters';
    }
    return null;
  }

  // Numeric range validator
  static String? validateNumericRange(
    String? value,
    num min,
    num max, {
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    final number = num.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < min) {
      return fieldName != null
          ? '$fieldName must be at least $min'
          : 'Must be at least $min';
    }
    if (number > max) {
      return fieldName != null
          ? '$fieldName cannot be more than $max'
          : 'Cannot be more than $max';
    }
    return null;
  }
}