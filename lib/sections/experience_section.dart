import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/responsive.dart';
import '../core/scroll_reveal.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_head.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Section(
      child: Column(
        children: [
          const SectionHead(
            eyebrow: 'Work Experience',
            title: 'Where the work happened',
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 780),
              child: Stack(
                children: [
                  // `.timeline::before` — the vertical gradient rail.
                  Positioned(
                    left: 22,
                    top: 6,
                    bottom: 6,
                    child: Opacity(
                      opacity: 0.35,
                      child: Container(
                        width: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [t.primary, t.accent],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      for (var i = 0; i < SiteConfig.experience.length; i++) ...[
                        if (i > 0) const SizedBox(height: 48),
                        Reveal(
                          delay: Duration(milliseconds: 80 * i),
                          child: _TimelineItem(entry: SiteConfig.experience[i]),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.entry});

  final ExperienceEntry entry;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 64),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          entry.role,
                          style: display(TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: t.ink,
                          )),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.company,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: t.primary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: t.bgSoft,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        entry.duration,
                        style: mono(TextStyle(fontSize: 12, color: t.muted2)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                for (final p in entry.points)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // `li::before` — a 45°-rotated accent square.
                        Padding(
                          padding: const EdgeInsets.only(top: 8, right: 12),
                          child: Transform.rotate(
                            angle: 0.785398,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: t.accent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            p,
                            style: TextStyle(fontSize: 14.5, height: 1.6, color: t.muted),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        // `.tl-dot`
        Positioned(
          left: 12,
          top: 4,
          child: Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: t.surface,
              border: Border.all(color: t.primary, width: 2),
            ),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: t.brandGradient,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
