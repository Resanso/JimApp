// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

/// Widget TextField kustom yang menyediakan tampilan yang seragam untuk input teks
/// dalam aplikasi.
class CustomTextField extends StatelessWidget {
  /// Controller untuk mengelola state dari input teks
  final TextEditingController controller;

  /// Teks label yang ditampilkan di atas field
  final String labelText;

  /// Teks petunjuk yang muncul ketika field kosong
  final String? hintText;

  /// Mengatur apakah teks yang dimasukkan harus disembunyikan (untuk password)
  final bool obscureText;

  /// Tipe keyboard yang akan ditampilkan (mis: number, email, dll)
  final TextInputType? keyboardType;

  /// Fungsi untuk memvalidasi input pengguna
  final String? Function(String?)? validator;

  /// Jumlah baris maksimal yang dapat diinput
  final int? maxLines;

  /// Gaya teks untuk input
  final TextStyle? style;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: style ?? AppStyles.body1,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        fillColor: AppColors.secondaryDark,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accentGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accentGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accentGreen, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}

/// Widget Dropdown kustom yang menyediakan tampilan yang seragam untuk pemilihan
/// opsi dalam aplikasi.
class CustomDropdownField<T> extends StatelessWidget {
  /// Nilai yang terpilih saat ini
  final T? value;

  /// Daftar item yang dapat dipilih dalam dropdown
  final List<DropdownMenuItem<T>> items;

  /// Fungsi yang dipanggil ketika pengguna memilih item baru
  final void Function(T?)? onChanged;

  /// Teks label yang ditampilkan di atas field
  final String labelText;

  /// Fungsi untuk memvalidasi pilihan pengguna
  final String? Function(T?)? validator;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      style: AppStyles.body1,
      dropdownColor: AppColors.secondaryDark,
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: AppColors.secondaryDark,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accentGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accentGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accentGreen, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
