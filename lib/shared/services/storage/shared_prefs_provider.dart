import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SharedPrefsProvider {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Profile data methods
  Future<String> getUserFullName() async {
    final prefs = await _prefs;
    return prefs.getString('userFullName') ?? 'User';
  }

  Future<void> setUserFullName(String value) async {
    final prefs = await _prefs;
    await prefs.setString('userFullName', value);
  }

  Future<String> getUserEmail() async {
    final prefs = await _prefs;
    return prefs.getString('userEmail') ?? 'user@example.com';
  }

  Future<void> setUserEmail(String value) async {
    final prefs = await _prefs;
    await prefs.setString('userEmail', value);
  }

  Future<String> getUserProfilePicture() async {
    final prefs = await _prefs;
    return prefs.getString('userProfilePicture') ?? '';
  }

  Future<void> setUserProfilePicture(String value) async {
    final prefs = await _prefs;
    await prefs.setString('userProfilePicture', value);
  }

  // Check if user has profile data
  Future<bool> hasProfileData() async {
    final prefs = await _prefs;
    final fullName = prefs.getString('userFullName');
    final email = prefs.getString('userEmail');
    final profilePicture = prefs.getString('userProfilePicture');

    return fullName != null && email != null && profilePicture != null;
  }

  Future<bool> isSetupComplete() async {
    final prefs = await _prefs;
    return prefs.getBool('isSetupComplete') ?? false;
  }

  Future<void> setSetupComplete(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool('isSetupComplete', value);
  }

  Future<DateTime?> getQuitDate() async {
    final prefs = await _prefs;
    final quitDateMillis = prefs.getInt('quitDate');
    if (quitDateMillis != null) {
      return DateTime.fromMillisecondsSinceEpoch(quitDateMillis);
    }
    return null;
  }

  Future<void> setQuitDate(DateTime date) async {
    final prefs = await _prefs;
    await prefs.setInt('quitDate', date.millisecondsSinceEpoch);
  }

  Future<double> getCigarettesPerDay() async {
    final prefs = await _prefs;
    // Convert stored int to double for backward compatibility
    final value = prefs.getInt('cigarettesPerDay');
    if (value != null) {
      return value.toDouble();
    }
    return 15.0;
  }

  Future<void> setCigarettesPerDay(double value) async {
    final prefs = await _prefs;
    // Store as int for backward compatibility
    await prefs.setInt('cigarettesPerDay', value.toInt());
  }

  Future<double> getPricePerPack() async {
    final prefs = await _prefs;
    return prefs.getDouble('pricePerPack') ?? 100.0;
  }

  Future<void> setPricePerPack(double value) async {
    final prefs = await _prefs;
    await prefs.setDouble('pricePerPack', value);
  }

  Future<double> getCigarettesPerPack() async {
    final prefs = await _prefs;
    // Convert stored int to double for backward compatibility
    final value = prefs.getInt('cigarettesPerPack');
    if (value != null) {
      return value.toDouble();
    }
    return 20.0;
  }

  Future<void> setCigarettesPerPack(double value) async {
    final prefs = await _prefs;
    // Store as int for backward compatibility
    await prefs.setInt('cigarettesPerPack', value.toInt());
  }

  Future<String> getUsername() async {
    final prefs = await _prefs;
    return prefs.getString('username') ?? 'GuestUser';
  }

  Future<void> setUsername(String value) async {
    final prefs = await _prefs;
    await prefs.setString('username', value);
  }

  // Clear all data (for logout/reset)
  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  // Get all data as map (for debugging)
  Future<Map<String, dynamic>> getAllData() async {
    final prefs = await _prefs;
    final keys = prefs.getKeys();
    final data = <String, dynamic>{};

    for (final key in keys) {
      data[key] = prefs.get(key);
    }

    return data;
  }

  // Validate that all required data is present
  Future<bool> hasAllRequiredData() async {
    final quitDate = await getQuitDate();
    final cigsPerDay = await getCigarettesPerDay();
    final cigsPerPack = await getCigarettesPerPack();
    final pricePerPack = await getPricePerPack();
    final isSetupCompleted = await isSetupComplete();

    return quitDate != null &&
        cigsPerDay > 0 &&
        cigsPerPack > 0 &&
        pricePerPack > 0 &&
        isSetupCompleted;
  }

  // Sync data with Firebase if user is logged in
  Future<bool> syncWithFirebase() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.email != null) {
        // User is logged in with email, sync data
        final quitDate = await getQuitDate();
        final cigsPerDay = await getCigarettesPerDay();
        final cigsPerPack = await getCigarettesPerPack();
        final pricePerPack = await getPricePerPack();
        final isSetupCompleted = await isSetupComplete();

        if (quitDate != null && isSetupCompleted) {
          try {
            final userRepository = Get.find();
            await userRepository.updateSmokingData(
              currentUser.uid,
              cigarettesCount: cigsPerDay,
              smokesPerPack: cigsPerPack,
              pricePerPack: pricePerPack,
              quitDate: quitDate,
              isOnboardingComplete: isSetupCompleted,
            );
            return true;
          } catch (e) {
            // Error syncing with Firebase
            return false;
          }
        }
      }
      return false;
    } catch (e) {
      // Error in syncWithFirebase
      return false;
    }
  }

  // Load data from Firebase to local storage
  Future<bool> loadFromFirebase(String userId) async {
    try {
      final userRepository = Get.find();
      final userData = await userRepository.fetchUserDetails(userId);

      if (userData.isOnboardingComplete) {
        if (userData.quitDate != null) {
          await setQuitDate(userData.quitDate!);
        }
        await setCigarettesPerDay(userData.cigarettesCount);
        await setCigarettesPerPack(userData.smokesPerPack);
        await setPricePerPack(userData.pricePerPack);
        await setSetupComplete(userData.isOnboardingComplete);

        // Load profile data
        await setUserFullName(userData.fullName);
        await setUserEmail(userData.email);
        await setUserProfilePicture(userData.profilePicture);
        await setUsername(userData.fullName);
        return true;
      }
      return false;
    } catch (e) {
      // Error loading from Firebase
      return false;
    }
  }
}
