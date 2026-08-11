import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/responsive.dart';
import '../core/scroll_reveal.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/hover.dart';
import '../widgets/section_head.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Section(
      background: t.bgSoft,
      child: Column(
        children: [
          const SectionHead(
            eyebrow: 'Technical Skills',
            title: 'The stack behind every release',
            subtitle: 'Tools and frameworks used daily to ship production Flutter apps.',
          ),
          ResponsiveGrid(
            columns: context.pick(desktop: 3, laptop: 2, mobile: 1),
            gap: 22,
            children: [
              for (var i = 0; i < SiteConfig.skillGroups.length; i++)
                Reveal(
                  delay: Duration(milliseconds: 60 * (i % 3)),
                  child: _SkillCard(group: SiteConfig.skillGroups[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.group});

  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Hover(
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: const Cubic(.2, .8, .2, 1),
        transform: Matrix4.translationValues(0, hovered ? -6 : 0, 0),
        child: GlassCard(
          shadow: hovered ? t.shadowLg : t.shadowSm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.layers_rounded, size: 15, color: t.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      group.group,
                      style: display(TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: t.ink,
                      )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              for (var i = 0; i < group.skills.length; i++) ...[
                if (i > 0) const SizedBox(height: 14),
                _SkillRow(skill: group.skills[i]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({required this.skill});

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill.name,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t.ink),
            ),
            Text('${skill.level}%', style: TextStyle(fontSize: 13, color: t.muted)),
          ],
        ),
        const SizedBox(height: 6),
        // `.bar-track` / `.bar-fill` — width animates in when scrolled into view.
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 6,
            color: t.borderSoft,
            child: OnVisible(
              duration: const Duration(milliseconds: 1200),
              builder: (context, progress) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (skill.level / 100) * progress,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: t.brandGradient,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
