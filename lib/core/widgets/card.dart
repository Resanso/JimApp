import 'dart:ui';

import 'package:flutter/material.dart';

class TransparentCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;
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
