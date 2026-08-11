import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/responsive.dart';
import '../core/scroll_reveal.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_head.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final narrow = context.isNarrow;

    return Section(
      child: narrow
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AboutCopy(),
                SizedBox(height: 44),
                _StatGrid(),
              ],
            )
          : const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 9, child: _AboutCopy()),
                SizedBox(width: 64),
                Expanded(flex: 11, child: _StatGrid()),
              ],
            ),
    );
  }
}

class _AboutCopy extends StatelessWidget {
  const _AboutCopy();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final bodyStyle = TextStyle(fontSize: 16.5, height: 1.6, color: t.muted);

    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('About'),
          const SizedBox(height: 14),
          Text(
            'Turning product ideas into\nreliable mobile apps.',
            style: display(TextStyle(
              fontSize: context.clampVw(30, 4, 44),
              fontWeight: FontWeight.w600,
              height: 1.08,
              letterSpacing: -0.9,
              color: t.ink,
            )),
          ),
          const SizedBox(height: 20),
          Text(SiteConfig.summary, style: bodyStyle),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: bodyStyle,
              children: [
                const TextSpan(text: 'Based in '),
                TextSpan(
                  text: SiteConfig.location,
                  style: bodyStyle.copyWith(color: t.ink, fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text: ', working across GetX, Bloc, Firebase and REST-driven '
                      'architectures — from customer-facing apps to the admin '
                      'consoles that run behind them.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final d in SiteConfig.domains) DomainChip(d),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid();

  @override
  Widget build(BuildContext context) {
    return Reveal(
      delay: const Duration(milliseconds: 100),
      child: ResponsiveGrid(
        columns: 2,
        gap: 18,
        children: [
          for (final s in SiteConfig.stats) _StatCard(stat: s),
        ],
      ),
    );
  }
}

/// `.stat-card` with the `IntersectionObserver` counter ease-out-cubic ramp.
class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final Stat stat;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnVisible(
            builder: (context, progress) => Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  (stat.value * progress).toStringAsFixed(stat.decimals),
                  style: mono(TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: t.primary,
                    height: 1.1,
                  )),
                ),
                Text(
                  stat.suffix,
                  style: mono(TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: t.primary,
                    height: 1.1,
                  )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stat.label,
            style: TextStyle(fontSize: 13.5, height: 1.4, color: t.muted),
          ),
        ],
      ),
    );
  }
}
