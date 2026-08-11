import 'package:flutter/material.dart';

/// `@keyframes float-y` / `photo-float` — a slow vertical bob with a per-element
/// delay so the hero elements don't move in lockstep.
class FloatY extends StatefulWidget {
  const FloatY({
    super.key,
    required this.child,
    this.distance = 14,
    this.period = const Duration(milliseconds: 4600),
    this.delay = Duration.zero,
  });

  final Widget child;
  final double distance;
  final Duration period;
  final Duration delay;

  @override
  State<FloatY> createState() => _FloatYState();
}

class _FloatYState extends State<FloatY> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.period);

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _c, curve: Curves.easeInOut),
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -widget.distance * Curves.easeInOut.transform(_c.value)),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// Text painted with `--gradient-brand` — the `background-clip: text` trick.
class GradientText extends StatelessWidget {
  const GradientText(this.text, {super.key, required this.style, required this.gradient, this.textAlign});

  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      blendMode: BlendMode.srcIn,
      child: Text(text, textAlign: textAlign, style: style.copyWith(color: Colors.white)),
    );
  }
}

/// The conic ring behind the hero portrait (`.photo-ring`, 7s linear spin).
class SpinningRing extends StatefulWidget {
  const SpinningRing({
    super.key,
    required this.colors,
    required this.size,
    required this.holeColor,
    this.thickness = 5,
    this.period = const Duration(seconds: 7),
  });

  final List<Color> colors;
  final double size;
  final Color holeColor;
  final double thickness;
  final Duration period;

  @override
  State<SpinningRing> createState() => _SpinningRingState();
}

class _SpinningRingState extends State<SpinningRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.period)..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _c,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(colors: [...widget.colors, widget.colors.first]),
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.thickness),
          child: DecoratedBox(
            decoration: BoxDecoration(shape: BoxShape.circle, color: widget.holeColor),
          ),
        ),
      ),
    );
  }
}
