import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../../../core/constants/app_strings.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C63FF),
              Color(0xFF9C8DFF),
              Color(0xFFB8B0FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.2),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: const Color.fromRGBO(255, 255, 255, 0.4),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.note_alt_outlined,
                  size: 60,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .scale(
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 32),

              // App Name
              Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
              )
                  .animate(delay: 300.ms)
                  .slideY(
                    begin: 0.5,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(duration: 600.ms),

              const SizedBox(height: 12),

              // Tagline
              Text(
                AppStrings.tagline,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color.fromRGBO(255, 255, 255, 0.85),
                      letterSpacing: 0.5,
                    ),
              )
                  .animate(delay: 500.ms)
                  .slideY(
                    begin: 0.5,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(duration: 600.ms),

              const SizedBox(height: 80),

              // Loading indicator
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(255, 255, 255, 0.7),
                  ),
                ),
              ).animate(delay: 800.ms).fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
