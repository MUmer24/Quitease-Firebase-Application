import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'features/auth/data/auth_wrapper/auth_wrapper.dart';
import 'shared/repositories/auth/authentication_repository.dart';
import 'core/theme/app_theme.dart';
import 'core/di/dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/config/firebase_options.dart';
import 'shared/services/notification/notification_service.dart';

Future<void> main() async {
  // Widgets Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: '.env');

  // GetStorage
  await GetStorage.init();

  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  // 'SharedPreferences initialized'
  Get.put<SharedPreferences>(prefs);

  // Await native splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  DependencyInjection.init();

  // Initialize notification service
  final notificationService = Get.find<NotificationService>();
  await notificationService.initialize();

  // Request notification permissions on Android 13+
  await notificationService.requestPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quitease Smoking',
      theme: SereneAscentTheme.appTheme,
      home: AuthWrapper(),
    );
  }
}
