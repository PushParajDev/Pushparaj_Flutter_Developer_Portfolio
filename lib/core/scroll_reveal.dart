import 'package:flutter/material.dart';

/// AOS replacement — `data-aos="fade-up|fade-left|zoom-in"` with `data-aos-delay`.
enum RevealAnim { fadeUp, fadeLeft, fadeRight, zoomIn }

/// Provides the page's scroll controller so every [Reveal] can test whether it
/// has entered the viewport. Also used by the skill bars and stat counters.
class ScrollScope extends InheritedWidget {
  const ScrollScope({super.key, required this.controller, required super.child});

  final ScrollController controller;

  static ScrollController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ScrollScope>()!.controller;

  static ScrollController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ScrollScope>()?.controller;

  @override
  bool updateShouldNotify(ScrollScope oldWidget) => controller != oldWidget.controller;
}

/// Animates its child in once, the first time it scrolls into view.
///
/// AOS defaults: `duration: 700, once: true, offset: 60, easing: ease-out-cubic`.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.anim = RevealAnim.fadeUp,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 700),
    this.offset = 60,
  });

  final Widget child;
  final RevealAnim anim;
  final Duration delay;
  final Duration duration;

  /// How far above the fold the element must be before it triggers.
  final double offset;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _t =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  ScrollController? _scroll;
  bool _fired = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = ScrollScope.maybeOf(context);
    if (next != _scroll) {
      _scroll?.removeListener(_check);
      _scroll = next;
      _scroll?.addListener(_check);
    }
  }

  void _check() {
    if (_fired || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final screenH = MediaQuery.sizeOf(context).height;
    if (top < screenH - widget.offset) {
      _fired = true;
      _scroll?.removeListener(_check);
      Future.delayed(widget.delay, () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _scroll?.removeListener(_check);
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (context, child) {
        final v = _t.value;
        final inv = 1 - v;
        final transform = switch (widget.anim) {
          RevealAnim.fadeUp => Matrix4.translationValues(0, 24 * inv, 0),
          RevealAnim.fadeLeft => Matrix4.translationValues(40 * inv, 0, 0),
          RevealAnim.fadeRight => Matrix4.translationValues(-40 * inv, 0, 0),
          RevealAnim.zoomIn => Matrix4.diagonal3Values(
              0.92 + 0.08 * v,
              0.92 + 0.08 * v,
              1,
            ),
        };
        return Opacity(
          opacity: v,
          child: Transform(
            transform: transform,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Runs [builder] with a 0→1 progress value once the widget enters the
/// viewport. Powers the stat counters and the skill bars (both of which used
/// an `IntersectionObserver` in the original).
class OnVisible extends StatefulWidget {
  const OnVisible({
    super.key,
    required this.builder,
    this.duration = const Duration(milliseconds: 1400),
    this.curve = Curves.easeOutCubic,
    this.threshold = 0.3,
  });

  final Widget Function(BuildContext context, double t) builder;
  final Duration duration;
  final Curve curve;

  /// Fraction of the viewport height the element must be inside.
  final double threshold;

  @override
  State<OnVisible> createState() => _OnVisibleState();
}

class _OnVisibleState extends State<OnVisible> {
  ScrollController? _scroll;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = ScrollScope.maybeOf(context);
    if (next != _scroll) {
      _scroll?.removeListener(_check);
      _scroll = next;
      _scroll?.addListener(_check);
    }
  }

  void _check() {
    if (_visible || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final screenH = MediaQuery.sizeOf(context).height;
    if (top < screenH * (1 - widget.threshold * 0.1) && top + box.size.height > 0) {
      _scroll?.removeListener(_check);
      setState(() => _visible = true);
    }
  }

  @override
  void dispose() {
    _scroll?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: _visible ? 1 : 0),
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, t, _) => widget.builder(context, t),
    );
  }
}
