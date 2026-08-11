import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/responsive.dart';
import '../core/scroll_reveal.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_head.dart';

class _Achievement {
  const _Achievement(this.icon, this.number, this.label);
  final AppIconData icon;
  final String number;
  final String label;
}

const _achievements = [
  _Achievement(AppIconData.material(Icons.phone_iphone_rounded), '10+', 'Production Apps'),
  _Achievement(AppIconData.material(Icons.account_tree_rounded), '50+', 'REST APIs'),
  _Achievement(AppIconData.fa(FontAwesomeIcons.googlePlay), 'Live', 'Play Store Apps'),
  _Achievement(AppIconData.fa(FontAwesomeIcons.appStoreIos), 'Live', 'App Store Apps'),
  _Achievement(AppIconData.material(Icons.bolt_rounded), '20%', 'Performance Gain'),
];

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      child: Column(
        children: [
          const SectionHead(eyebrow: 'Achievements', title: 'Milestones so far'),
          ResponsiveGrid(
            columns: context.pick(desktop: 5, laptop: 3, mobile: 2),
            gap: 16,
            children: [
              for (var i = 0; i < _achievements.length; i++)
                Reveal(
                  anim: RevealAnim.zoomIn,
                  delay: Duration(milliseconds: 60 * i),
                  child: _AchieveCard(item: _achievements[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AchieveCard extends StatelessWidget {
  const _AchieveCard({required this.item});

  final _Achievement item;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(item.icon, size: 22, color: t.primary),
          const SizedBox(height: 14),
          Text(
            item.number,
            style: mono(TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: t.ink,
            )),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, height: 1.4, color: t.muted),
          ),
        ],
      ),
    );
  }
}
