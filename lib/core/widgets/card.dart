import 'dart:ui';
import 'package:flutter/material.dart';

/// Widget Card transparan yang memberikan efek blur pada latar belakangnya.
///
/// Widget ini menggunakan [BackdropFilter] untuk memberikan efek blur dan
/// [ColorFilter] untuk mengatur transparansi.
///
/// Contoh penggunaan:
/// ```dart
/// TransparentCard(
///   child: Text('Konten card'),
///   padding: EdgeInsets.all(16),
///   elevation: 2,
/// )
/// ```
class TransparentCard extends StatelessWidget {
  /// Widget yang akan ditampilkan di dalam card
  final Widget child;

  /// Padding internal card
  /// Nilai default adalah EdgeInsets.all(16)
  final EdgeInsetsGeometry? padding;

  /// Margin eksternal card
  /// Tidak memiliki nilai default
  final EdgeInsetsGeometry? margin;

  /// Tingkat elevasi/bayangan card
  /// Nilai default adalah 2
  final double elevation;

  /// Radius sudut card
  /// Nilai default adalah BorderRadius.all(Radius.circular(12))
  final BorderRadius? borderRadius;

  const TransparentCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.elevation = 2,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.white.withOpacity(0.0),
        BlendMode.srcOver,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Card(
          margin: margin,
          elevation: elevation,
          color: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius!,
            side: BorderSide(
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          child: Padding(
            padding: padding!,
            child: child,
          ),
        ),
      ),
    );
  }
}
