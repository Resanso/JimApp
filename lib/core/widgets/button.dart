import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

/// Widget tombol kustom yang dapat disesuaikan dengan berbagai properti.
///
/// Properti yang tersedia:
/// - [text] : Teks yang akan ditampilkan pada tombol
/// - [onPressed] : Fungsi yang akan dipanggil ketika tombol ditekan
/// - [backgroundColor] : Warna latar belakang tombol (opsional)
/// - [textColor] : Warna teks tombol (opsional)
/// - [width] : Lebar tombol (opsional)
/// - [height] : Tinggi tombol (default: 50)
/// - [isLoading] : Status loading tombol (default: false)
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final bool isLoading;

  /// Membuat instance dari [CustomButton].
  ///
  /// Parameter [text] dan [onPressed] wajib diisi.
  /// Parameter lainnya bersifat opsional dan memiliki nilai default.
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.accentGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                color: textColor ?? Colors.white,
              )
            : Text(
                text,
                style: AppStyles.button.copyWith(
                  color: textColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}

/// Widget tombol ikon kustom yang dapat disesuaikan dengan berbagai properti.
///
/// Properti yang tersedia:
/// - [icon] : Ikon yang akan ditampilkan pada tombol
/// - [onPressed] : Fungsi yang akan dipanggil ketika tombol ditekan
/// - [backgroundColor] : Warna latar belakang tombol (opsional)
/// - [iconColor] : Warna ikon (opsional)
/// - [size] : Ukuran ikon (default: 24)
class IconCustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  /// Membuat instance dari [IconCustomButton].
  ///
  /// Parameter [icon] dan [onPressed] wajib diisi.
  /// Parameter lainnya bersifat opsional dan memiliki nilai default.
  const IconCustomButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: iconColor ?? AppColors.textPrimary,
        size: size,
      ),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.accentGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
