import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/utils/formatters/formatter.dart';

/// Model class representing user data.
class UserModel {
  final String id;
  String fullName;
  String email;
  String profilePicture;

  DateTime? createdAt;
  DateTime? updatedAt;

  // --- Smoking Cessation Data ---
  final double cigarettesCount;
  final double smokesPerPack;
  final double pricePerPack;
  final DateTime? quitDate;
  final bool isOnboardingComplete;

  String deviceToken;

  /// Constructor for UserModel.
  UserModel({
    required this.id,
    required this.email,
    this.fullName = '',
    this.profilePicture = '',
    this.createdAt,
    this.updatedAt,
    // Default values for new users
    this.cigarettesCount = 0.0,
    this.smokesPerPack = 0.0,
    this.pricePerPack = 0.0,
    this.quitDate,
    this.isOnboardingComplete = false,
    this.deviceToken = '',
  });

  /// Helper methods

  String get formattedDate => DataFormatter.formatDateAndTime(createdAt);
  String get formattedUpdatedAtDate =>
      DataFormatter.formatDateAndTime(updatedAt);

  /// Static function to split full name into first and last name.
  static List<String> nameParts(String fullName) => fullName.split(" ");

  /// Static function to generate a username from the full name.
  static String generateUsername(String fullName) {
    String usernameWithPrefix = "umtech_$fullName"; // Add "umtech_" prefix
    return usernameWithPrefix;
  }

  /// Static function to create an empty user model.
  static UserModel empty() =>
      UserModel(id: '', email: ''); // Default createdAt to current time

  // Helper function to check if the onboarding data is complete
  bool get isOnboardingCompleteCheck {
    // You can define "completeness" however you need.
    // Here, we check if key fields have been set to non-default values.
    return cigarettesCount > 0 && smokesPerPack > 0 && quitDate != null;
  }

  /// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'profilePicture': profilePicture,
      'deviceToken': deviceToken,
      'createdAt': createdAt,
      'updatedAt': DateTime.now(),

      'cigarettesCount': cigarettesCount,
      'smokesPerPack': smokesPerPack,
      'pricePerPack': pricePerPack,
      'quitDate': quitDate,
      'isOnboardingComplete': isOnboardingComplete,
    };
  }

  // Factory method to create UserModel from Firestore document snapshot
  factory UserModel.fromDocSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return UserModel.fromJson(doc.id, data);
  }

  // Static method to create a list of UserModel from QuerySnapshot (for retrieving multiple users)
  static UserModel fromQuerySnapshot(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson(doc.id, data);
  }

  // ----------------------------------------------------------------------------------------------------------
  /// Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromJson(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      deviceToken: data['deviceToken'] ?? '',

      // Handle Timestamps
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      quitDate: (data['quitDate'] as Timestamp?)?.toDate(),

      cigarettesCount: (data['cigarettesCount'] ?? 0).toDouble(),
      smokesPerPack: (data['smokesPerPack'] ?? 0).toDouble(),
      pricePerPack: (data['pricePerPack'] ?? 0.0).toDouble(),
      isOnboardingComplete: data['isOnboardingComplete'] ?? false,
    );
  }

  /// Create a copy with updated smoking data
  UserModel copyWithSmokingData({
    double? cigarettesCount,
    double? smokesPerPack,
    double? pricePerPack,
    DateTime? quitDate,
    bool? isOnboardingComplete,
    String? fullName,
    String? profilePicture,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      profilePicture: profilePicture ?? this.profilePicture,
      deviceToken: deviceToken,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      cigarettesCount: cigarettesCount ?? this.cigarettesCount,
      smokesPerPack: smokesPerPack ?? this.smokesPerPack,
      pricePerPack: pricePerPack ?? this.pricePerPack,
      quitDate: quitDate ?? this.quitDate,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }

  /// Create a copy with updated profile information
  UserModel copyWithProfile({
    String? fullName,
    String? profilePicture,
    String? deviceToken,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      profilePicture: profilePicture ?? this.profilePicture,
      deviceToken: deviceToken ?? this.deviceToken,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      cigarettesCount: cigarettesCount,
      smokesPerPack: smokesPerPack,
      pricePerPack: pricePerPack,
      quitDate: quitDate,
      isOnboardingComplete: isOnboardingComplete,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, fullName: $fullName, isOnboardingComplete: $isOnboardingComplete)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
