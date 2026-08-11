import 'package:flutter/material.dart';

import 'cursor_fx.dart';

/// The `:hover { transform: translateY(-Npx) }` + shadow-swap pattern that
/// nearly every card in `style.css` uses.
class Hover extends StatefulWidget {
  const Hover({
    super.key,
    required this.builder,
    this.onTap,
    this.cursor = SystemMouseCursors.basic,
    this.duration = const Duration(milliseconds: 300),
  });

  final Widget Function(BuildContext context, bool hovered) builder;
  final VoidCallback? onTap;
  final MouseCursor cursor;
  final Duration duration;

  @override
  State<Hover> createState() => _HoverState();
}

class _HoverState extends State<Hover> {
  bool _hovered = false;

  @override
  void dispose() {
    // Don't leave the cursor dot stuck in its grown state if we unmount while
    // the pointer is still inside (e.g. a modal closing).
    if (_hovered) CursorFx.exit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : widget.cursor,
      onEnter: (_) {
        CursorFx.enter();
        setState(() => _hovered = true);
      },
      onExit: (_) {
        CursorFx.exit();
        setState(() => _hovered = false);
      },
      child: widget.builder(context, _hovered),
    );
    if (widget.onTap == null) return child;
    return GestureDetector(onTap: widget.onTap, child: child);
  }
}

/// Lifts a child by [lift] logical pixels on hover — the cubic-bezier(.2,.8,.2,1)
/// easing from the stylesheet.
class HoverLift extends StatelessWidget {
  const HoverLift({
    super.key,
    required this.child,
    this.lift = 6,
    this.onTap,
    this.duration = const Duration(milliseconds: 300),
  });

  final Widget child;
  final double lift;
  final VoidCallback? onTap;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Hover(
      onTap: onTap,
      builder: (context, hovered) => AnimatedContainer(
        duration: duration,
        curve: const Cubic(.2, .8, .2, 1),
        transform: Matrix4.translationValues(0, hovered ? -lift : 0, 0),
        child: child,
      ),
    );
  }
}
