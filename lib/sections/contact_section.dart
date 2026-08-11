import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../config/site_config.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import '../core/scroll_reveal.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import '../widgets/glass_card.dart';
import '../widgets/hover.dart';
import '../widgets/section_head.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      child: Column(
        children: [
          const SectionHead(
            eyebrow: 'Contact',
            title: "Let's build something together",
            subtitle: 'Reach out directly — I usually reply within a day.',
          ),
          ResponsiveGrid(
            columns: context.pick(desktop: 4, laptop: 2, mobile: 1),
            gap: 18,
            children: [
              Reveal(
                child: _ContactCard(
                  icon: const AppIconData.material(Icons.phone_rounded),
                  title: 'Phone',
                  value: SiteConfig.phone,
                  action: 'Call Now',
                  onTap: Links.phone,
                ),
              ),
              Reveal(
                delay: const Duration(milliseconds: 60),
                child: _ContactCard(
                  icon: const AppIconData.fa(FontAwesomeIcons.whatsapp),
                  title: 'WhatsApp',
                  value: SiteConfig.phone,
                  action: 'Open Chat',
                  onTap: Links.whatsapp,
                ),
              ),
              Reveal(
                delay: const Duration(milliseconds: 120),
                child: _ContactCard(
                  icon: const AppIconData.material(Icons.mail_outline_rounded),
                  title: 'Email',
                  value: SiteConfig.email,
                  action: 'Send Email',
                  onTap: Links.email,
                ),
              ),
              Reveal(
                delay: const Duration(milliseconds: 180),
                child: _ContactCard(
                  icon: const AppIconData.fa(FontAwesomeIcons.linkedinIn),
                  title: 'LinkedIn',
                  value: 'Connect professionally',
                  action: 'View Profile',
                  onTap: Links.linkedin,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.action,
    required this.onTap,
  });

  final AppIconData icon;
  final String title;
  final String value;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Hover(
      onTap: onTap,
      duration: const Duration(milliseconds: 250),
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, hovered ? -5 : 0, 0),
        child: GlassCard(
          shadow: hovered ? t.shadowLg : t.shadowSm,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIcon(icon, size: 19, color: t.primary),
              const SizedBox(height: 14),
              Text(
                title,
                style: display(TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: t.ink,
                )),
              ),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 13, height: 1.5, color: t.muted)),
              const SizedBox(height: 14),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    action,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: t.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 13, color: t.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
