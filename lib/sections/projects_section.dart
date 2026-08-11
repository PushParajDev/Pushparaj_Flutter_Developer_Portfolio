import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../config/site_config.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import '../core/scroll_reveal.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_icon.dart';
import '../widgets/glass_card.dart';
import '../widgets/hover.dart';
import '../widgets/section_head.dart';
import 'project_modal.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Section(
      background: t.bgSoft,
      child: Column(
        children: [
          const SectionHead(
            eyebrow: 'Selected Work',
            title: 'Apps shipped to real users',
            subtitle:
                'Each card opens a full case study — features, tech stack, '
                'challenges and how they were solved.',
          ),
          ResponsiveGrid(
            columns: context.pick(desktop: 3, laptop: 2, mobile: 1),
            gap: 26,
            children: [
              for (var i = 0; i < SiteConfig.projects.length; i++)
                Reveal(
                  delay: Duration(milliseconds: 60 * (i % 3)),
                  child: ProjectCard(project: SiteConfig.projects[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Hover(
      onTap: () => showProjectModal(context, project),
      duration: const Duration(milliseconds: 350),
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: const Cubic(.2, .8, .2, 1),
        transform: Matrix4.translationValues(0, hovered ? -8 : 0, 0),
        child: GlassCard(
          clip: true,
          shadow: hovered ? t.shadowLg : t.shadowSm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Thumb(project: project, hovered: hovered),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.tagline.toUpperCase(),
                      style: mono(
                        TextStyle(
                          fontSize: 11.5,
                          letterSpacing: 0.9,
                          color: t.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.name,
                      style: display(
                        TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: t.ink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.shortDescription,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: t.muted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final tech in project.tech.take(4)) TechTag(tech),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (project.android != "#") ...[
                          const SizedBox(width: 10),
                          const IconLinkBox(
                            icon: AppIconData.fa(FontAwesomeIcons.android),
                            tooltip: 'Android',
                          ),
                        ],

                        if (project.ios != "#") ...[
                          const SizedBox(width: 10),
                          const IconLinkBox(
                            icon: AppIconData.fa(FontAwesomeIcons.apple),
                            tooltip: 'iOS',
                          ),
                        ],

                        if (project.github.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          IconLinkBox(
                            icon: const AppIconData.fa(FontAwesomeIcons.github),
                            tooltip: 'GitHub',
                            onTap: () => Links.open(project.github),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `.project-thumb` — gradient placeholder with the project name, scaling on
/// hover, plus the bottom scrim.
class _Thumb extends StatelessWidget {
  const _Thumb({required this.project, required this.hovered});

  final Project project;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return SizedBox(
      height: 160,
      width: double.infinity,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              scale: hovered ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                project.thumb,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),

            // Bottom dark overlay
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0x47000000)],
                  stops: [0.4, 1],
                ),
              ),
              child: SizedBox.expand(),
            ),
          ],
        ),
      ),
    );
  }
}
