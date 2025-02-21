// lib/core/constants/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Private constructor
  AppColors._();

  // Primary Colors
  static const Color primaryDark = Color(0xFF121418);
  static const Color secondaryDark = Color(0xFF1E2126);
  static const Color accentRed = Color(0xFFFF4B6E);
  static const Color accentGreen = Color(0xFF4ECCA3);

  // Secondary Colors
  static const Color darkGrey = Color(0xFF2D3035);
  static const Color gold = Color(0xFFFFD369);
  static const Color mediumGrey = Color(0xFF9CA3AF);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFE5E7EB);
  static const Color deepDark = Color(0xFF0B0D0F);

  // Gradients
  static LinearGradient get energyGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accentRed, Color(0xFFFF8F70)],
      );

  static LinearGradient get premiumGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [secondaryDark, deepDark],
      );

  // Text Colors
  static const Color textPrimary = white;
  static const Color textSecondary = lightGrey;
  static const Color textAccent = gold;

  // Utility Colors
  static const Color dividerColor = darkGrey;
  static const Color buttonDisabled = mediumGrey;

  // ignore: prefer_typing_uninitialized_variables
  static var primaryLight;

  // ignore: prefer_typing_uninitialized_variables
  static var accentBlue;
}

/* Contoh Penggunaan:
1. Untuk background scaffold:
backgroundColor: AppColors.primaryDark

2. Untuk tombol utama:
backgroundColor: AppColors.accentRed
textColor: AppColors.textPrimary

3. Untuk progress bar:
color: AppColors.accentGreen

4. Untuk gradien:
Container(
  decoration: BoxDecoration(
    gradient: AppColors.energyGradient,
  ),
)

5. Untuk teks premium:
Text(
  'VIP MEMBER',
  style: TextStyle(color: AppColors.textAccent),
)
*/