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

class _MuscleAnatomyState extends State<MuscleAnatomy> {
  String? _processedSvg;

  Future<void> _processSvg() async {
    final string = await DefaultAssetBundle.of(context)
        .loadString('assets/anatomy/body3.svg');

    String processed = string;

    // Set warna default untuk semua path dengan fill="#D9D9D9"
    processed = processed.replaceAll('fill="#D9D9D9"', 'fill="#E0E0E0"');

    // Warnai otot yang dilatih
    for (String muscle in widget.trainedMuscles) {
      // Pattern untuk mencocokkan ID otot baik dengan suffix _left/right atau tidak
      final regexp = RegExp('id="$muscle(?:_left|_right)?"[^>]*?fill="[^"]*"');

      // Dapatkan warna dari callback
      final Color color = widget.colorCallback(muscle);
      final String colorHex =
          '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';

      // Ganti fill color pada path yang sesuai
      processed = processed.replaceAllMapped(
        regexp,
        (match) =>
            match
                .group(0)
                ?.replaceAll(RegExp('fill="[^"]*"'), 'fill="$colorHex"') ??
            '',
      );
    }

    setState(() {
      _processedSvg = processed;
    });
  }

  @override
  void initState() {
    super.initState();
    _processSvg();
    ever(widget.trainedMuscles, (_) => _processSvg());
  }

  @override
  Widget build(BuildContext context) {
    if (_processedSvg == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SvgPicture.string(
      _processedSvg!,
      semanticsLabel: 'Anatomy',
      fit: BoxFit.contain,
      height: 400,
    );
  }
}
