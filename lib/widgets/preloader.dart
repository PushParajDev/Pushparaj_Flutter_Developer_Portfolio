import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// `#preloader` — the pulsing "P" mark and the sweeping loader bar, faded out
/// 350ms after first paint.
class Preloader extends StatefulWidget {
  const Preloader({super.key, required this.child});

  final Widget child;

  @override
  State<Preloader> createState() => _PreloaderState();
}

class _PreloaderState extends State<Preloader> with TickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  late final AnimationController _bar = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  bool _loaded = false;
  bool _removed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _loaded = true);
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (mounted) setState(() => _removed = true);
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    _bar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Stack(
      children: [
        widget.child,
        if (!_removed)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: _loaded,
              child: AnimatedOpacity(
                opacity: _loaded ? 0 : 1,
                duration: const Duration(milliseconds: 600),
                child: ColoredBox(
                  color: t.bg,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleTransition(
                          scale: Tween(begin: 1.0, end: 0.86).animate(
                            CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                          ),
                          child: Container(
                            width: 52,
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: t.brandGradient,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              'P',
                              style: display(const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 160,
                          height: 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: ColoredBox(
                              color: t.border,
                              child: AnimatedBuilder(
                                animation: _bar,
                                builder: (context, _) => Align(
                                  alignment: Alignment(-1 + 2 * _bar.value * 1.4, 0),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.4,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(gradient: t.brandGradient),
                                      child: const SizedBox.expand(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
