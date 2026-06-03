import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/register_controller.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../domain/usecases/auth_usecases.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/auth_header.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      RegisterController(registerUseCase: Get.find<RegisterUseCase>()),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const AuthHeader(
                title: 'Create\nAccount',
                subtitle: 'Join us and start organizing your notes',
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),

              const SizedBox(height: 40),

              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    // Name Field
                    CustomTextField(
                      controller: controller.nameController,
                      label: AppStrings.name,
                      hint: 'Name',
                      keyboardType: TextInputType.name,
                      prefixIcon: Icons.person_outline,
                      validator: Validators.validateName,
                    ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.2),

                    const SizedBox(height: 16),

                    // Email Field
                    CustomTextField(
                      controller: controller.emailController,
                      label: AppStrings.email,
                      hint: 'E-mail',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.validateEmail,
                    ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.2),

                    const SizedBox(height: 16),

                    // Password Field
                    Obx(() => CustomTextField(
                          controller: controller.passwordController,
                          label: AppStrings.password,
                          hint: '••••••••',
                          obscureText: !controller.isPasswordVisible.value,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: controller.isPasswordVisible.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onSuffixTap: controller.togglePasswordVisibility,
                          validator: Validators.validatePassword,
                        )).animate(delay: 300.ms).fadeIn().slideX(begin: -0.2),

                    const SizedBox(height: 32),

                    // Register Button
                    Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.register,
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(AppStrings.signUp),
                        )).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3),

                    const SizedBox(height: 24),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.alreadyHaveAccount,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textMedium,
                                  ),
                        ),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Text(
                            AppStrings.signIn,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ],
                    ).animate(delay: 500.ms).fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
