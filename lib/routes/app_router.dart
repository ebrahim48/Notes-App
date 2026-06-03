import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';
import '../domain/entities/note_entity.dart';
import '../presentation/splash/pages/splash_page.dart';
import '../presentation/auth/login/pages/login_page.dart';
import '../presentation/auth/register/pages/register_page.dart';
import '../presentation/home/pages/home_page.dart';
import '../presentation/add_note/pages/add_note_page.dart';

class AppRouter {
  // Sharing Get.key as the navigator key lets GetX overlays (snackbars, dialogs)
  // work alongside go_router without needing GetMaterialApp.
  static final router = GoRouter(
    navigatorKey: Get.key,
    initialLocation: AppConstants.splashRoute,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppConstants.splashRoute,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppConstants.homeRoute,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppConstants.addNoteRoute,
        name: 'add-note',
        builder: (context, state) {
          final note = state.extra as NoteEntity?;
          return AddNotePage(existingNote: note);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );

  static String? _redirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final location = state.uri.toString();

    if (location == AppConstants.splashRoute) return null;

    if (!isLoggedIn &&
        location != AppConstants.loginRoute &&
        location != AppConstants.registerRoute) {
      return AppConstants.loginRoute;
    }

    if (isLoggedIn &&
        (location == AppConstants.loginRoute ||
            location == AppConstants.registerRoute)) {
      return AppConstants.homeRoute;
    }

    return null;
  }
}
