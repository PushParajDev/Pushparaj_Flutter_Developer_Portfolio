import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import '../theme/app_theme.dart';
import '../widgets/hover.dart';
import 'hero_section.dart';
import 'navbar.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key, required this.onNavigate, required this.year});

  final void Function(SectionId) onNavigate;
  final int year;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final mobile = context.isMobile;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: t.border)),
      ),
      padding: const EdgeInsets.only(top: 56, bottom: 28),
      child: SiteContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FooterBrand(),
                  const SizedBox(height: 32),
                  _FooterLinks(onNavigate: onNavigate),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _FooterBrand(),
                  _FooterLinks(onNavigate: onNavigate),
                ],
              ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.only(top: 24),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: t.borderSoft)),
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  Text(
                    '© $year ${SiteConfig.name}. All rights reserved.',
                    style: TextStyle(fontSize: 13, color: t.muted2),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Designed with ',
                        style: TextStyle(fontSize: 13, color: t.muted2),
                      ),
                      const Icon(Icons.favorite, size: 12, color: Color(0xFFE5484D)),
                      Text(
                        ' by ${SiteConfig.name}',
                        style: TextStyle(fontSize: 13, color: t.muted2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: t.brandGradient,
                borderRadius: BorderRadius.circular(AppTokens.radiusSm),
                boxShadow: t.shadowGlow,
              ),
              child: Text(
                'P',
                style: display(const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                )),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Pushparaj',
              style: display(TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: t.ink,
              )),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            'Flutter Developer building scalable, production-ready mobile apps.',
            style: TextStyle(fontSize: 14, height: 1.6, color: t.muted),
          ),
        ),
        const SizedBox(height: 18),
        const SocialRow(size: 38),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks({required this.onNavigate});

  final void Function(SectionId) onNavigate;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 56,
      runSpacing: 32,
      children: [
        _FooterColumn(
          title: 'Quick Links',
          children: [
            _FooterLink('Projects', () => onNavigate(SectionId.projects)),
            _FooterLink('Skills', () => onNavigate(SectionId.skills)),
            _FooterLink('Experience', () => onNavigate(SectionId.experience)),
            _FooterLink('Contact', () => onNavigate(SectionId.contact)),
          ],
        ),
        _FooterColumn(
          title: 'Contact',
          children: [
            _FooterLink(SiteConfig.phone, Links.phone),
            _FooterLink(SiteConfig.email, Links.email),
            Builder(
              builder: (context) => Text(
                SiteConfig.location,
                style: TextStyle(fontSize: 14, color: context.tokens.muted),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title.toUpperCase(),
          style: mono(TextStyle(fontSize: 12, letterSpacing: 1, color: t.muted2)),
        ),
        const SizedBox(height: 14),
        for (final child in children)
          Padding(padding: const EdgeInsets.only(bottom: 10), child: child),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Hover(
      onTap: onTap,
      builder: (context, hovered) => Text(
        label,
        style: TextStyle(fontSize: 14, color: hovered ? t.primary : t.muted),
      ),
    );
  }
}
