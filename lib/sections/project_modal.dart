import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../config/site_config.dart';
import '../core/links.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_icon.dart';
import '../widgets/hover.dart';
import '../widgets/section_head.dart';

/// `.modal-overlay` — opens the full case study for a project.
Future<void> showProjectModal(BuildContext context, Project project) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: project.name,
    barrierColor: const Color(0xA8060B16),
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (context, anim, secondaryAnim) =>
        _ProjectModal(project: project),
    transitionBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: const Cubic(.2, .8, .2, 1),
      );
      return FadeTransition(
        opacity: anim,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - curved.value)),
          child: Transform.scale(
            scale: 0.98 + 0.02 * curved.value,
            child: child,
          ),
        ),
      );
    },
  );
}

class _ProjectModal extends StatelessWidget {
  const _ProjectModal({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final maxH = MediaQuery.sizeOf(context).height * 0.88;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 780, maxHeight: maxH),
          child: Material(
            color: t.surface,
            borderRadius: BorderRadius.circular(AppTokens.radiusLg),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _GallerySlider(project: project),
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: _ModalBody(project: project),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 24,
                  child: Hover(
                    onTap: () => Navigator.of(context).pop(),
                    builder: (context, hovered) => Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: t.surfaceGlass,
                        border: Border.all(
                          color: hovered ? t.primary : t.border,
                        ),
                      ),
                      child: Icon(Icons.close_rounded, size: 18, color: t.ink),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `.modal-hero .swiper` — auto-advancing placeholder slides, one per gallery
/// image, on the brand gradient.
class _GallerySlider extends StatefulWidget {
  const _GallerySlider({required this.project});

  final Project project;

  @override
  State<_GallerySlider> createState() => _GallerySliderState();
}

class _GallerySliderState extends State<_GallerySlider> {
  final _controller = PageController();
  Timer? _timer;
  int _page = 0;

  int get _count => 1;

  @override
  void initState() {
    super.initState();
    if (_count > 1) {
      _timer = Timer.periodic(const Duration(milliseconds: 2800), (_) {
        if (!mounted || !_controller.hasClients) return;
        _controller.animateToPage(
          (_page + 1) % _count,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return SizedBox(
      height: 320,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: t.brandGradient),
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _count,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => Center(
                child: Image.asset(
                  widget.project.thumb,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
            if (_count > 1)
              Positioned(
                bottom: 14,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _count; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == _page ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: i == _page ? .95 : .45,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
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

class _ModalBody extends StatelessWidget {
  const _ModalBody({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project.tagline.toUpperCase(),
          style: mono(
            TextStyle(fontSize: 12, letterSpacing: 1, color: t.primary),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          project.name,
          style: display(
            TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              color: t.ink,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          project.description,
          style: TextStyle(fontSize: 15, height: 1.6, color: t.muted),
        ),
        const SizedBox(height: 20),
        _ModalSection(
          title: 'My Role',
          child: Text(
            project.role,
            style: TextStyle(fontSize: 14.5, height: 1.6, color: t.ink),
          ),
        ),
        _ModalSection(
          title: 'Key Features',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final f in project.features)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3, right: 8),
                        child: Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: t.primary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 14.5,
                            height: 1.5,
                            color: t.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        _ModalSection(
          title: 'Challenge',
          child: Text(
            project.challenges,
            style: TextStyle(fontSize: 14.5, height: 1.6, color: t.muted),
          ),
        ),
        _ModalSection(
          title: 'Solution',
          child: Text(
            project.solutions,
            style: TextStyle(fontSize: 14.5, height: 1.6, color: t.muted),
          ),
        ),
        _ModalSection(
          title: 'Tech Stack',
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final tech in project.tech) TechTag(tech)],
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 10,
          runSpacing: 10,
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
    );
  }
}

class _ModalSection extends StatelessWidget {
  const _ModalSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: mono(
              TextStyle(fontSize: 13, letterSpacing: 0.8, color: t.muted2),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
