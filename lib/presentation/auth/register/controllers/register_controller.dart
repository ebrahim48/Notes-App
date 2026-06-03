import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/usecases/auth_usecases.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/constants/app_strings.dart';

class RegisterController extends GetxController {
  final RegisterUseCase _registerUseCase;

  RegisterController({required RegisterUseCase registerUseCase})
      : _registerUseCase = registerUseCase;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      await _registerUseCase(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      Get.context?.go(AppConstants.homeRoute);
    } catch (e) {
      AppSnackbar.error(_getFirebaseError(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  String _getFirebaseError(String error) {
    if (error.contains('email-already-in-use')) return 'Email is already in use.';
    if (error.contains('weak-password')) return 'Password is too weak.';
    if (error.contains('network-request-failed')) return 'Network error. Check connection.';
    return AppStrings.somethingWentWrong;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
