import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/responsive.dart';
import '../core/scroll_reveal.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_head.dart';

class CertificationsSection extends StatelessWidget {
  const CertificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final certs = SiteConfig.certifications;

    return Section(
      background: t.bgSoft,
      child: Column(
        children: [
          const SectionHead(eyebrow: 'Certifications', title: 'Continued learning'),
          if (certs.isEmpty)
            // `.cert-empty` — dashed placeholder while the list is empty.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                border: Border.all(color: t.border, style: BorderStyle.solid),
              ),
              child: Text(
                "Certifications will be added here as they're completed.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.5, color: t.muted),
              ),
            )
          else
            ResponsiveGrid(
              columns: context.pick(desktop: 3, laptop: 2, mobile: 1),
              gap: 20,
              children: [
                for (var i = 0; i < certs.length; i++)
                  Reveal(
                    delay: Duration(milliseconds: 60 * (i % 3)),
                    child: _CertCard(cert: certs[i]),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CertCard extends StatelessWidget {
  const _CertCard({required this.cert});

  final Certification cert;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 14),
            child: Icon(Icons.workspace_premium_rounded, size: 20, color: t.primary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cert.title,
                  style: display(TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: t.ink,
                  )),
                ),
                const SizedBox(height: 4),
                Text(
                  '${cert.issuer} · ${cert.year}',
                  style: TextStyle(fontSize: 12.5, color: t.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
