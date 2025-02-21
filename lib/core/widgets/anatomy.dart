import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MuscleAnatomy extends StatefulWidget {
  final RxList<String> trainedMuscles;
  final Color Function(String) colorCallback;

  const MuscleAnatomy({
    Key? key,
    required this.trainedMuscles,
    required this.colorCallback,
  }) : super(key: key);

  @override
  State<MuscleAnatomy> createState() => _MuscleAnatomyState();
}

class _MuscleAnatomyState extends State<MuscleAnatomy>
    with SingleTickerProviderStateMixin {
  String? _staticSvg;
  String? _animatedSvg;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Bisa disesuaikan
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.7, // Nilai minimum opacity
      end: 1.0, // Nilai maximum opacity
    ).animate(_animationController);

    _processSvg();
    ever(widget.trainedMuscles, (_) => _processSvg());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _processSvg() async {
    final string = await DefaultAssetBundle.of(context)
        .loadString('assets/anatomy/body3.svg');

    String staticPaths = string;
    String animatedPaths = string;

    // Set default color for all paths
    staticPaths = staticPaths.replaceAll('fill="#D9D9D9"', 'fill="#E0E0E0"');
    animatedPaths =
        animatedPaths.replaceAll('fill="#D9D9D9"', 'fill="#E0E0E0"');

    // Process each trained muscle
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

    return Stack(
      alignment: Alignment.center, // Tambahkan alignment
      fit: StackFit.expand, // Memastikan Stack mengisi ruang yang tersedia
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
