import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 3));
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final context = Get.context;
    if (context == null || !context.mounted) return;
    if (isLoggedIn) {
      context.go(AppConstants.homeRoute);
    } else {
      context.go(AppConstants.loginRoute);
    }
  }
}
