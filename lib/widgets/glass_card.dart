import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// `.glass` — translucent surface, 18px backdrop blur, hairline border,
/// 24px radius.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(26),
    this.radius = AppTokens.radiusLg,
    this.shadow,
    this.blur = 18,
    this.borderColor,
    this.clip = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final List<BoxShadow>? shadow;
  final double blur;
  final Color? borderColor;

  /// Set when the card holds an image/thumb that must be clipped to the radius.
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final r = BorderRadius.circular(radius);

    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: r, boxShadow: shadow ?? t.shadowSm),
      child: ClipRRect(
        borderRadius: r,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: t.surfaceGlass,
              borderRadius: r,
              border: Border.all(color: borderColor ?? t.border, width: 1),
            ),
            padding: clip ? EdgeInsets.zero : padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A solid (non-blurred) surface card — used where the CSS used `--surface`
/// directly, e.g. the code window and the modal box.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = AppTokens.radiusMd,
    this.shadow,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: t.border),
        boxShadow: shadow ?? t.shadowLg,
      ),
      child: child,
    );
  }
}
