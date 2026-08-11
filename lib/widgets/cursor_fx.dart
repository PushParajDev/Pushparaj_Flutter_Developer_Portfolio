import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// `.cursor-fx` — the 8px dot that trails the pointer on precise-pointer
/// devices and swells over interactive elements.
class CursorFx {
  const CursorFx._();

  static final ValueNotifier<Offset?> position = ValueNotifier(null);
  static final ValueNotifier<int> hoverCount = ValueNotifier(0);

  static void enter() => hoverCount.value++;
  static void exit() {
    if (hoverCount.value > 0) hoverCount.value--;
  }
}

class CursorFxOverlay extends StatelessWidget {
  const CursorFxOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // `@media (pointer:fine)` — skip on touch devices.
    final fine = defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux;
    if (!fine) return child;

    final t = context.tokens;
    return MouseRegion(
      opaque: false,
      onHover: (e) => CursorFx.position.value = e.position,
      onExit: (_) => CursorFx.position.value = null,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: IgnorePointer(
              child: ValueListenableBuilder<Offset?>(
                valueListenable: CursorFx.position,
                builder: (context, pos, _) {
                  if (pos == null) return const SizedBox.shrink();
                  return ValueListenableBuilder<int>(
                    valueListenable: CursorFx.hoverCount,
                    builder: (context, count, _) {
                      final grown = count > 0;
                      final size = grown ? 27.0 : 8.0;
                      return Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 90),
                            left: pos.dx - size / 2,
                            top: pos.dy - size / 2,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: t.primary.withValues(alpha: grown ? .28 : .9),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
