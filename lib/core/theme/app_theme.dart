// ------------------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/utils/enums.dart';

/// A comprehensive theme definition for the "Serene Ascent: Azure Edition" app.
class SereneAscentTheme {
  static const Map<SereneAscentPaletteColor, Color> _rawColors = {
    SereneAscentPaletteColor.backgroundWhite: Color(0xFFFFFFFF),
    SereneAscentPaletteColor.skyBlue: Color(0xFF64B5F6),
    SereneAscentPaletteColor.deepBlue: Color(0xFF1976D2),
    SereneAscentPaletteColor.growthGreen: Color(0xFF81C784),
    SereneAscentPaletteColor.lightGreyBlue: Color(0xFFF8F9FA),
    SereneAscentPaletteColor.pureWhite: Color.fromARGB(235, 248, 250, 252),
    SereneAscentPaletteColor.charcoalGrey: Color(0xFF2F3E46),
    SereneAscentPaletteColor.mediumGrey: Color(0xFF6C757D),
    SereneAscentPaletteColor.warningYellow: Color(0xFFFFC107),
    SereneAscentPaletteColor.successGreen: Color(0xFF28A745),
    SereneAscentPaletteColor.errorRed: Color(0xFFDC3545),
  };

  /// Public getter for theme color
  static Color getColor(SereneAscentPaletteColor color) => _rawColors[color]!;

  static ColorScheme get colorScheme {
    return ColorScheme(
      primary: _rawColors[SereneAscentPaletteColor.deepBlue]!,
      onPrimary: _rawColors[SereneAscentPaletteColor.backgroundWhite]!,
      secondary: _rawColors[SereneAscentPaletteColor.deepBlue]!,
      onSecondary: _rawColors[SereneAscentPaletteColor.backgroundWhite]!,
      error: _rawColors[SereneAscentPaletteColor.errorRed]!,
      onError: _rawColors[SereneAscentPaletteColor.backgroundWhite]!,
      surface: _rawColors[SereneAscentPaletteColor.backgroundWhite]!,
      onSurface: _rawColors[SereneAscentPaletteColor.charcoalGrey]!,
      brightness: Brightness.light,
      tertiary: _rawColors[SereneAscentPaletteColor.growthGreen],
      onTertiary: _rawColors[SereneAscentPaletteColor.charcoalGrey],
      primaryContainer: _rawColors[SereneAscentPaletteColor.skyBlue]!,
      onPrimaryContainer: _rawColors[SereneAscentPaletteColor.backgroundWhite]!,
      secondaryContainer: _rawColors[SereneAscentPaletteColor.deepBlue]!,
    );
  }

  static const String primaryFontFamily = 'Poppins';

  static TextTheme get _appTextTheme {
    const defaultFontFamily = primaryFontFamily;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.w700,
        color: _rawColors[SereneAscentPaletteColor.charcoalGrey],
        fontFamily: defaultFontFamily,
      ),
      headlineLarge: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
        color: _rawColors[SereneAscentPaletteColor.charcoalGrey],
        fontFamily: defaultFontFamily,
      ),
      headlineMedium: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w500,
        color: _rawColors[SereneAscentPaletteColor.charcoalGrey],
        fontFamily: defaultFontFamily,
      ),
      headlineSmall: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: _rawColors[SereneAscentPaletteColor.charcoalGrey],
        fontFamily: defaultFontFamily,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: _rawColors[SereneAscentPaletteColor.charcoalGrey],
        fontFamily: defaultFontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: _rawColors[SereneAscentPaletteColor.charcoalGrey],
        fontFamily: defaultFontFamily,
      ),
      labelSmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        color: _rawColors[SereneAscentPaletteColor.mediumGrey],
        fontFamily: defaultFontFamily,
      ),
      titleMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: _rawColors[SereneAscentPaletteColor.mediumGrey],
        fontFamily: defaultFontFamily,
      ),
      titleSmall: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: _rawColors[SereneAscentPaletteColor.skyBlue],
        fontFamily: defaultFontFamily,
      ),
    );
  }

  static SereneAscentShapes get shapes => SereneAscentShapes();
  static SereneAscentShadows get shadows => SereneAscentShadows();

  static ThemeData get appTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: primaryFontFamily,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: _appTextTheme,
      snackBarTheme: snackBarTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shapes.buttonBorderRadius),
          ),
          shadowColor: shadows.buttonShadowColor,
          elevation: shadows.buttonElevation,
          textStyle: _appTextTheme.titleMedium,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 2.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shapes.buttonBorderRadius),
          ),
          textStyle: _appTextTheme.titleSmall,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          textStyle: _appTextTheme.bodyMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        // CORRECTED: Use surface for component backgrounds
        fillColor: colorScheme.surface,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapes.inputBorderRadius),
          borderSide: BorderSide(
            color: _rawColors[SereneAscentPaletteColor.mediumGrey]!.withAlpha(
              128,
            ),
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapes.inputBorderRadius),
          borderSide: BorderSide(
            color: _rawColors[SereneAscentPaletteColor.mediumGrey]!.withAlpha(
              128,
            ),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapes.inputBorderRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        hintStyle: TextStyle(
          color: _rawColors[SereneAscentPaletteColor.mediumGrey]!.withAlpha(
            178,
          ),
          fontFamily: primaryFontFamily,
        ),
        labelStyle: TextStyle(
          color: _rawColors[SereneAscentPaletteColor.charcoalGrey],
          fontFamily: primaryFontFamily,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: shadows.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shapes.cardBorderRadius),
        ),
        shadowColor: shadows.cardShadow.color,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 1.0,
        titleTextStyle: _appTextTheme.headlineMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24.0),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        circularTrackColor: colorScheme.surface,
        linearTrackColor: colorScheme.surface,
      ),
      dividerColor: _rawColors[SereneAscentPaletteColor.mediumGrey]!.withAlpha(
        77,
      ),
    );
  }

  static SnackBarThemeData get snackBarTheme {
    return SnackBarThemeData(
      backgroundColor: colorScheme.surface,
      contentTextStyle: _appTextTheme.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(shapes.cardBorderRadius),
      ),
      elevation: shadows.cardElevation,
      behavior: SnackBarBehavior.floating,
      actionTextColor: colorScheme.primary,
    );
  }

  static void customToast({required String message}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(
              message,
              style: Theme.of(Get.context!).textTheme.bodySmall,
            ),
          ),
        ),
      ),
    );
  }
}

class SereneAscentShapes {
  final double buttonBorderRadius = 8.0;
  final double cardBorderRadius = 12.0;
  final double inputBorderRadius = 6.0;
}

class SereneAscentShadows {
  final Color buttonShadowColor = Colors.black.withAlpha(26);
  final double buttonElevation = 2.0;
  final double cardElevation = 4.0;
  final BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withAlpha(20),
    blurRadius: 10.0,
    offset: const Offset(0, 4),
  );
}
