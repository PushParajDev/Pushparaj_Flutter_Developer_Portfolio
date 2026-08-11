import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Either a Material icon or a Font Awesome one.
///
/// font_awesome_flutter v11 hands out `FaIconData`, which must be rendered by
/// `FaIcon` (the plain `Icon` widget clips non-square brand glyphs). This lets
/// the shared widgets take one icon type and render whichever is correct.
@immutable
class AppIconData {
  const AppIconData.material(IconData this.material) : fa = null;
  const AppIconData.fa(FaIconData this.fa) : material = null;

  final IconData? material;
  final FaIconData? fa;
}

class AppIcon extends StatelessWidget {
  const AppIcon(this.icon, {super.key, this.size, this.color});

  final AppIconData icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (icon.fa != null) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(child: FaIcon(icon.fa, size: size, color: color)),
      );
    }
    return Icon(icon.material, size: size, color: color);
  }
}
