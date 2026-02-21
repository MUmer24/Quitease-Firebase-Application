import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/user_model.dart';
import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to save user data to Firestore.
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // / Function to fetch user details based on user ID.
  Future<UserModel> fetchUserDetails(String userId) async {
    try {
      final documentSnapshot = await _db.collection("Users").doc(userId).get();
      if (documentSnapshot.exists) {
        return UserModel.fromDocSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to update user data in Firestore.
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db
          .collection("Users")
          .doc(updatedUser.id)
          .update(updatedUser.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Function to update smoking data specifically
  Future<void> updateSmokingData(
    String userId, {
    required double cigarettesCount,
    required double smokesPerPack,
    required double pricePerPack,
    required DateTime quitDate,
    required bool isOnboardingComplete,
  }) async {
    try {
      await _db.collection("Users").doc(userId).update({
        'cigarettesCount': cigarettesCount,
        'smokesPerPack': smokesPerPack,
        'pricePerPack': pricePerPack,
        'quitDate': quitDate,
        'isOnboardingComplete': isOnboardingComplete,
        'updatedAt': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to check if user exists and get their data
  Future<UserModel?> getUserIfExists(String userId) async {
    try {
      final docSnapshot = await _db.collection("Users").doc(userId).get();
      if (docSnapshot.exists) {
        return UserModel.fromDocSnapshot(docSnapshot);
      }
      return null;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
