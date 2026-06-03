class AppConstants {
  AppConstants._();

  // Route Names
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String addNoteRoute = '/add-note';
  static const String editNoteRoute = '/edit-note';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String notesCollection = 'notes';

  // SharedPreferences Keys
  static const String splashShownKey = 'splash_shown';

  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordMinLength = 'Password must be at least 6 characters';
  static const String nameRequired = 'Name is required';
  static const String titleRequired = 'Title is required';
  static const String descriptionRequired = 'Description is required';
}
