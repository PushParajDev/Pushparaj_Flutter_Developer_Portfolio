import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/scroll_reveal.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
import '../sections/about_section.dart';
import '../sections/achievements_section.dart';
import '../sections/availability_section.dart';
import '../sections/certifications_section.dart';
import '../sections/contact_section.dart';
import '../sections/experience_section.dart';
import '../sections/footer_section.dart';
import '../sections/hero_section.dart';
import '../sections/navbar.dart';
import '../sections/projects_section.dart';
import '../sections/screenshots_section.dart';
import '../sections/services_section.dart';
import '../sections/skills_section.dart';
import '../widgets/hover.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scroll = ScrollController();
  final _keys = {for (final s in SectionId.values) s: GlobalKey()};

  bool _scrolled = false;
  bool _showBackToTop = false;
  bool _menuOpen = false;
  SectionId _active = SectionId.home;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    final y = _scroll.offset;
    final scrolled = y > 40;
    final showBackToTop = y > 500;
    final active = _activeSection();

    if (scrolled != _scrolled ||
        showBackToTop != _showBackToTop ||
        active != _active) {
      setState(() {
        _scrolled = scrolled;
        _showBackToTop = showBackToTop;
        _active = active;
      });
    }
  }

  /// `highlightActiveNav()` — the last section whose top has passed 120px.
  SectionId _activeSection() {
    var current = SectionId.home;
    for (final entry in _keys.entries) {
      final box = entry.value.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      if (box.localToGlobal(Offset.zero).dy <= 120) current = entry.key;
    }
    return current;
  }

  Future<void> _navigate(SectionId id) async {
    if (_menuOpen) setState(() => _menuOpen = false);

    if (id == SectionId.home) {
      await _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      return;
    }

    final box = _keys[id]?.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final target =
        (_scroll.offset +
                box.localToGlobal(Offset.zero).dy -
                AppTokens.navHeightScrolled)
            .clamp(0.0, _scroll.position.maxScrollExtent);
    await _scroll.animateTo(
      target,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final theme = ThemeScope.of(context);
    final year = DateTime.now().year;

    return Scaffold(
      backgroundColor: t.bg,
      body: ScrollScope(
        controller: _scroll,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scroll,
              child: Column(
                children: [
                  KeyedSubtree(
                    key: _keys[SectionId.home],
                    child: HeroSection(onNavigate: _navigate),
                  ),
                  KeyedSubtree(
                    key: _keys[SectionId.about],
                    child: const AboutSection(),
                  ),
                  KeyedSubtree(
                    key: _keys[SectionId.skills],
                    child: const SkillsSection(),
                  ),
                  KeyedSubtree(
                    key: _keys[SectionId.experience],
                    child: const ExperienceSection(),
                  ),
                  KeyedSubtree(
                    key: _keys[SectionId.projects],
                    child: const ProjectsSection(),
                  ),
                  //const ScreenshotsSection(),
                  KeyedSubtree(
                    key: _keys[SectionId.services],
                    child: const ServicesSection(),
                  ),
                  const AchievementsSection(),
                  //const CertificationsSection(),
                  AvailabilitySection(onNavigate: _navigate),
                  KeyedSubtree(
                    key: _keys[SectionId.contact],
                    child: const ContactSection(),
                  ),
                  FooterSection(onNavigate: _navigate, year: year),
                ],
              ),
            ),

            // fixed navbar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Navbar(
                scrolled: _scrolled,
                active: _active,
                isDark: theme.isDark(context),
                onToggleTheme: () => theme.toggle(context),
                onNavigate: _navigate,
                menuOpen: _menuOpen,
                onToggleMenu: () => setState(() => _menuOpen = !_menuOpen),
              ),
            ),

            // slide-in menu below 940px
            if (context.isNarrow)
              Positioned(
                top: AppTokens.navHeightScrolled,
                left: 0,
                right: 0,
                bottom: 0,
                child: MobileMenu(
                  open: _menuOpen,
                  active: _active,
                  onNavigate: _navigate,
                ),
              ),

            // `.back-to-top`
            Positioned(
              right: 26,
              bottom: 26,
              child: IgnorePointer(
                ignoring: !_showBackToTop,
                child: AnimatedOpacity(
                  opacity: _showBackToTop ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedSlide(
                    offset: Offset(0, _showBackToTop ? 0 : 0.3),
                    duration: const Duration(milliseconds: 300),
                    child: Hover(
                      onTap: () => _navigate(SectionId.home),
                      builder: (context, hovered) => Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: t.brandGradient,
                          boxShadow: t.shadowLg,
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
