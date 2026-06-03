import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/usecases/auth_usecases.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/constants/app_strings.dart';

class LoginController extends GetxController {
  final LoginUseCase _loginUseCase;

  LoginController({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      await _loginUseCase(
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
    if (error.contains('user-not-found')) return 'No user found with this email.';
    if (error.contains('wrong-password')) return 'Incorrect password.';
    if (error.contains('invalid-credential')) return 'Invalid email or password.';
    if (error.contains('too-many-requests')) return 'Too many attempts. Try later.';
    if (error.contains('network-request-failed')) return 'Network error. Check connection.';
    return AppStrings.somethingWentWrong;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
