import 'package:flutter/widgets.dart';
import '../theme/app_theme.dart';

/// The three CSS breakpoints from `style.css`: 1080px, 940px, 720px.
enum Breakpoint { mobile, tablet, laptop, desktop }

extension ResponsiveX on BuildContext {
  double get screenW => MediaQuery.sizeOf(this).width;

  Breakpoint get bp {
    final w = screenW;
    if (w <= 720) return Breakpoint.mobile;
    if (w <= 940) return Breakpoint.tablet;
    if (w <= 1080) return Breakpoint.laptop;
    return Breakpoint.desktop;
  }

  bool get isMobile => bp == Breakpoint.mobile;
  bool get isNarrow => screenW <= 940; // hero/about stack, burger menu appears

  /// Picks a value per breakpoint, widest wins as the default.
  T pick<T>({required T desktop, T? laptop, T? tablet, T? mobile}) => switch (bp) {
        Breakpoint.mobile => mobile ?? tablet ?? laptop ?? desktop,
        Breakpoint.tablet => tablet ?? laptop ?? desktop,
        Breakpoint.laptop => laptop ?? desktop,
        Breakpoint.desktop => desktop,
      };

  /// `clamp(min, preferred vw, max)` from CSS.
  double clampVw(double min, double vw, double max) =>
      (screenW * vw / 100).clamp(min, max);
}

/// `.container { max-width: 1180px; margin: 0 auto; padding: 0 24px; }`
class SiteContainer extends StatelessWidget {
  const SiteContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppTokens.containerWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        ),
      ),
    );
  }
}

/// `.section { padding: 120px 0 }` — 80px under 720px.
class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.child,
    this.background,
    this.topPadding,
    this.bottomPadding,
  });

  final Widget child;
  final Color? background;
  final double? topPadding;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context) {
    final pad = context.isMobile ? 80.0 : 120.0;
    return Container(
      width: double.infinity,
      color: background,
      padding: EdgeInsets.only(
        top: topPadding ?? pad,
        bottom: bottomPadding ?? pad,
      ),
      child: SiteContainer(child: child),
    );
  }
}

/// A CSS-grid-like wrapper: fixed column count, equal widths, fixed gap.
///
/// Rows are laid out with `IntrinsicHeight` so cards in the same row match
/// heights, the way `display:grid` does.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    required this.columns,
    this.gap = 22,
    this.runGap,
  });

  final List<Widget> children;
  final int columns;
  final double gap;
  final double? runGap;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    final cols = columns.clamp(1, children.length);
    final rows = <List<Widget>>[];
    for (var i = 0; i < children.length; i += cols) {
      rows.add(children.sublist(i, (i + cols).clamp(0, children.length)));
    }

    return Column(
      children: [
        for (var r = 0; r < rows.length; r++) ...[
          if (r > 0) SizedBox(height: runGap ?? gap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var c = 0; c < cols; c++) ...[
                  if (c > 0) SizedBox(width: gap),
                  Expanded(
                    child: c < rows[r].length ? rows[r][c] : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
