import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central access point for all environment variables.
///
/// Usage:
/// ```dart
/// final clientId = AppEnv.googleServerClientId;
/// ```
///
/// Setup: Run `cp .env.example .env` and fill in your values.
/// Then call `await dotenv.load(fileName: ".env");` in main().
class AppEnv {
  AppEnv._(); // Prevent instantiation

  // -------------------------------------------------------
  // FIREBASE — Android
  // -------------------------------------------------------
  static String get firebaseAndroidApiKey =>
      dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? '';

  static String get firebaseAndroidAppId =>
      dotenv.env['FIREBASE_ANDROID_APP_ID'] ?? '';

  static String get firebaseMessagingSenderId =>
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';

  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';

  static String get firebaseDatabaseUrl =>
      dotenv.env['FIREBASE_DATABASE_URL'] ?? '';

  static String get firebaseStorageBucket =>
      dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';

  // -------------------------------------------------------
  // FIREBASE — Web
  // -------------------------------------------------------
  static String get firebaseWebApiKey =>
      dotenv.env['FIREBASE_WEB_API_KEY'] ?? '';

  static String get firebaseWebAppId => dotenv.env['FIREBASE_WEB_APP_ID'] ?? '';

  static String get firebaseAuthDomain =>
      dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '';

  static String get firebaseMeasurementId =>
      dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '';

  // -------------------------------------------------------
  // GOOGLE SIGN-IN
  // -------------------------------------------------------

  /// The OAuth 2.0 Web Client ID (serverClientId) used for Google Sign-In.
  /// Required to obtain ID tokens for Firebase Auth on Android.
  static String get googleServerClientId =>
      dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? '';

  // -------------------------------------------------------
  // APP CONFIG
  // -------------------------------------------------------
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'development';
  static bool get isProduction => appEnv == 'production';
  static bool get isDevelopment => appEnv == 'development';
}
