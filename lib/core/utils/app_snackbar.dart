import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: AppTheme.accent.withValues(alpha: 0.9),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  static void error(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: AppTheme.error.withValues(alpha: 0.9),
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  static void info(String message) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: AppTheme.primary.withValues(alpha: 0.9),
      colorText: Colors.white,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
