import 'dart:async';

import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/responsive.dart';
import '../theme/app_theme.dart';
import '../widgets/hover.dart';
import '../widgets/section_head.dart';

/// The Swiper carousel of phone mockups: centered slides, looping, autoplay
/// every 3.2s, 1.3 / 2 / 3.2 slides per view across the breakpoints.
class ScreenshotsSection extends StatefulWidget {
  const ScreenshotsSection({super.key});

  @override
  State<ScreenshotsSection> createState() => _ScreenshotsSectionState();
}

class _ScreenshotsSectionState extends State<ScreenshotsSection> {
  static const _initialPage = 10000;

  PageController? _controller;
  double _viewportFraction = 0;
  Timer? _timer;
  int _page = _initialPage;

  int get _count => SiteConfig.projects.length;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 3200), (_) {
      final c = _controller;
      if (!mounted || c == null || !c.hasClients) return;
      c.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void _syncController(double fraction) {
    if (_viewportFraction == fraction) return;
    _viewportFraction = fraction;
    _controller?.dispose();
    _controller = PageController(
      initialPage: _page,
      viewportFraction: fraction,
    );
  }

  void _jump(int delta) {
    _controller?.animateToPage(
      _page + delta,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final perView = context.pick<double>(desktop: 3.2, laptop: 2, tablet: 2, mobile: 1.3);
    _syncController(1 / perView);

    return Section(
      child: Column(
        children: [
          const SectionHead(
            eyebrow: 'App Screenshots',
            title: 'A closer look, screen by screen',
          ),
          SizedBox(
            height: 500,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) {
                    final project = SiteConfig.projects[i % _count];
                    return AnimatedScale(
                      scale: i == _page ? 1 : 0.92,
                      duration: const Duration(milliseconds: 300),
                      child: PhoneFrame(
                        title: project.name,
                        subtitle: project.tagline,
                      ),
                    );
                  },
                ),
                if (!context.isMobile) ...[
                  Positioned(
                    left: 0,
                    child: _NavArrow(icon: Icons.chevron_left_rounded, onTap: () => _jump(-1)),
                  ),
                  Positioned(
                    right: 0,
                    child: _NavArrow(icon: Icons.chevron_right_rounded, onTap: () => _jump(1)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < _count; i++)
                Hover(
                  onTap: () => _jump(i - _page % _count),
                  builder: (context, hovered) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page % _count ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _page % _count
                          ? context.tokens.primary
                          : context.tokens.muted.withValues(alpha: .4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// `.phone-frame` — 220×460 device shell with a notch and a gradient screen.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Center(
      child: Container(
        width: 220,
        height: 460,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: t.ink,
          borderRadius: BorderRadius.circular(34),
          boxShadow: t.shadowLg,
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: t.brandGradient),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: mono(TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: .95),
                          )),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: mono(TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: Colors.white.withValues(alpha: .85),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // notch
            Container(
              width: 70,
              height: 18,
              decoration: BoxDecoration(
                color: t.ink,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  const _NavArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Hover(
      onTap: onTap,
      builder: (context, hovered) => Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: t.surface,
          border: Border.all(color: hovered ? t.primary : t.border),
          boxShadow: t.shadowMd,
        ),
        child: Icon(icon, color: t.primary, size: 24),
      ),
    );
  }
}
