import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/responsive.dart';
import '../core/scroll_reveal.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/hover.dart';
import '../widgets/section_head.dart';

/// The `serviceIcons` lookup from `script.js`.
IconData serviceIconFor(ServiceIcon icon) => switch (icon) {
      ServiceIcon.flutter => Icons.layers_rounded,
      ServiceIcon.api => Icons.power_rounded,
      ServiceIcon.payment => Icons.credit_card_rounded,
      ServiceIcon.publish => Icons.rocket_launch_rounded,
      ServiceIcon.ui => Icons.palette_rounded,
      ServiceIcon.perf => Icons.speed_rounded,
    };

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Section(
      background: t.bgSoft,
      child: Column(
        children: [
          const SectionHead(
            eyebrow: 'Services',
            title: 'How I can help your team',
          ),
          ResponsiveGrid(
            columns: context.pick(desktop: 3, laptop: 2, mobile: 1),
            gap: 22,
            children: [
              for (var i = 0; i < SiteConfig.services.length; i++)
                Reveal(
                  delay: Duration(milliseconds: 60 * (i % 3)),
                  child: _ServiceCard(service: SiteConfig.services[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Hover(
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(0, hovered ? -6 : 0, 0),
        child: GlassCard(
          shadow: hovered ? t.shadowLg : t.shadowSm,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: t.primary100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(serviceIconFor(service.icon), size: 20, color: t.primary),
              ),
              const SizedBox(height: 18),
              Text(
                service.title,
                style: display(TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: t.ink,
                )),
              ),
              const SizedBox(height: 10),
              Text(
                service.desc,
                style: TextStyle(fontSize: 14, height: 1.6, color: t.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
