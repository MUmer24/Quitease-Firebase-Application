import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A utility class for managing a full-screen loading overlay
class LoadingOverlay {
  static bool _isShowing = false;

  /// Show a full-screen loading overlay with optional message
  static void show({String? message}) {
    if (_isShowing) return; // Prevent multiple overlays

    _isShowing = true;

    Get.dialog(
      PopScope(
        canPop: false, // Prevent dismissing with back button
        child: Material(
          color: Colors.black54, // Semi-transparent background
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF1976D2),
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black54,
    );
  }

  /// Hide the loading overlay
  static void hide() {
    if (_isShowing) {
      _isShowing = false;
      Get.back();
    }
  }

  /// Check if overlay is currently showing
  static bool get isShowing => _isShowing;
}
