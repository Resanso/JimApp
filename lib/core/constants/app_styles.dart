// lib/core/constants/app_styles.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';

class AppStyles {
  // Private constructor
  AppStyles._();

  /* ========== Text Styles ========== */
  // Heading
  static TextStyle heading1 = const TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: AppSizes.textHeading1,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -1,
  );

  static TextStyle heading2 = const TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: AppSizes.textHeading2,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle heading3 = const TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: AppSizes.textHeading3,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Body Text
  static TextStyle body1 = const TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: AppSizes.textBody1,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle body2 = const TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: AppSizes.textBody2,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Caption
  static TextStyle caption = const TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: AppSizes.textCaption,
    fontWeight: FontWeight.w500,
    color: AppColors.mediumGrey,
  );

  // Button Text
  static TextStyle button = const TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: AppSizes.textBody1,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  /* ========== Input Decoration ========== */
  static InputDecorationTheme inputDecoration = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.deepDark,
    contentPadding: const EdgeInsets.all(AppSizes.spaceMedium),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      borderSide:
          BorderSide(color: AppColors.accentGreen.withOpacity(0.5), width: 2),
    ),
    hintStyle: body2.copyWith(color: AppColors.mediumGrey),
    labelStyle: body2.copyWith(color: AppColors.textSecondary),
  );

  /* ========== Button Styles ========== */
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    minimumSize: const Size(AppSizes.buttonWidth, AppSizes.buttonHeight),
    backgroundColor: AppColors.accentRed,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
    ),
    elevation: AppSizes.buttonElevation,
  );

  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    side: const BorderSide(color: AppColors.accentRed),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
    ),
  );

  /* ========== Card Theme ========== */
  static CardTheme cardTheme = CardTheme(
    color: AppColors.secondaryDark,
    margin: const EdgeInsets.all(AppSizes.spaceSmall),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
    ),
    elevation: 8,
  );

  /* ========== Custom Text Theme ========== */
  static TextTheme textTheme = TextTheme(
    displayLarge: heading1,
    displayMedium: heading2,
    displaySmall: heading3,
    bodyLarge: body1,
    bodyMedium: body2,
    labelLarge: button,
    bodySmall: caption,
  );

  /* ========== Helper Methods ========== */
  static TextStyle sectionTitle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: AppColors.accentGreen,
          fontWeight: FontWeight.w600,
        );
  }
}
