import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/// Widget yang menampilkan anatomi otot tubuh manusia dengan kemampuan
/// untuk menyorot otot-otot yang sedang dilatih.
///
/// Widget ini menggunakan SVG untuk menampilkan gambar anatomi dan mendukung
/// animasi pulsing (berkedip) pada otot-otot yang dipilih.
class MuscleAnatomy extends StatefulWidget {
  /// List yang berisi nama-nama otot yang sedang dilatih.
  /// Perubahan pada list ini akan memicu pembaruan tampilan otot.
  final RxList<String> trainedMuscles;

  /// Fungsi callback yang menentukan warna untuk setiap otot.
  /// Menerima nama otot sebagai parameter dan mengembalikan Color.
  final Color Function(String) colorCallback;

  const MuscleAnatomy({
    super.key,
    required this.trainedMuscles,
    required this.colorCallback,
  });

  @override
  State<MuscleAnatomy> createState() => _MuscleAnatomyState();
}

class _MuscleAnatomyState extends State<MuscleAnatomy>
    with SingleTickerProviderStateMixin {
  /// Menyimpan SVG untuk otot-otot yang tidak dilatih (statis)
  String? _staticSvg;

  /// Menyimpan SVG untuk otot-otot yang sedang dilatih (beranimasi)
  String? _animatedSvg;

  /// Controller untuk mengatur animasi kedipan
  late AnimationController _animationController;

  /// Animasi opacity untuk efek kedipan
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller animasi
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Konfigurasi animasi opacity
    _opacityAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(_animationController);

    // Memproses SVG pertama kali
    _processSvg();
    // Memantau perubahan pada trainedMuscles
    ever(widget.trainedMuscles, (_) => _processSvg());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Memproses file SVG anatomi dan memisahkan antara
  /// otot yang dilatih dan tidak dilatih.
  ///
  /// Method ini akan:
  /// 1. Memuat file SVG dari assets
  /// 2. Memisahkan path untuk otot statis dan beranimasi
  /// 3. Mengatur warna sesuai status otot
  Future<void> _processSvg() async {
    final string = await DefaultAssetBundle.of(context)
        .loadString('assets/anatomy/body3.svg');

    String staticPaths = string;
    String animatedPaths = string;

    // Set warna default untuk semua path
    staticPaths = staticPaths.replaceAll('fill="#D9D9D9"', 'fill="#E0E0E0"');
    animatedPaths =
        animatedPaths.replaceAll('fill="#D9D9D9"', 'fill="#E0E0E0"');

    // Proses setiap otot yang dilatih
    for (String muscle in widget.trainedMuscles) {
      final regexp =
          RegExp('(<path[^>]*id="$muscle(?:_left|_right)?"[^>]*?/>)');

      // Remove trained muscles from static SVG
      staticPaths = staticPaths.replaceAll(regexp, '');

      // Set color for trained muscles in animated SVG and remove untrained muscles
      final Color baseColor =
          Colors.red.withOpacity(0.8); // Bisa diganti warna lain
      final String colorHex =
          '#${baseColor.value.toRadixString(16).padLeft(8, '0').substring(2)}';

      animatedPaths = animatedPaths.replaceAllMapped(
        regexp,
        (match) =>
            match.group(0)?.replaceAll(
                  RegExp('fill="[^"]*"'),
                  'fill="$colorHex"',
                ) ??
            '',
      );

      // Remove untrained muscles from animated SVG
      final allPaths = RegExp('(<path[^>]*?/>)');
      animatedPaths = animatedPaths.replaceAllMapped(
        allPaths,
        (match) {
          final path = match.group(0) ?? '';
          return widget.trainedMuscles.any((m) => path.contains('id="$m'))
              ? path
              : '';
        },
      );
    }

    setState(() {
      _staticSvg = staticPaths;
      _animatedSvg = animatedPaths;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_staticSvg == null || _animatedSvg == null) {
      return const Center(child: CircularProgressIndicator());
    }

    /// Membangun tampilan dengan dua lapisan SVG:
    /// 1. Lapisan dasar: otot-otot yang tidak dilatih (statis)
    /// 2. Lapisan atas: otot-otot yang dilatih (beranimasi)
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        // Static untrained muscles
        Positioned.fill(
          // Memastikan gambar mengisi Stack
          child: SvgPicture.string(
            _staticSvg!,
            semanticsLabel: 'Anatomy Static',
            fit: BoxFit.contain,
          ),
        ),
        // Animated trained muscles
        Positioned.fill(
          // Memastikan gambar mengisi Stack
          child: AnimatedBuilder(
            animation: _opacityAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: SvgPicture.string(
                  _animatedSvg!,
                  semanticsLabel: 'Anatomy Animated',
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
