/// Application-wide constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Info
  static const String appName = 'Star Wars Explorer';
  static const String appVersion = '1.0.0';

  // Navigation
  static const int defaultTabIndex = 0;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultElevation = 2.0;

  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;

  // Error Messages
  static const String networkErrorMessage = 'No internet connection';
  static const String serverErrorMessage =
      'Server error. Please try again later';
  static const String unknownErrorMessage = 'An unknown error occurred';
  static const String authErrorMessage = 'Authentication failed';
  static const String notFoundErrorMessage = 'Data not found';
}
