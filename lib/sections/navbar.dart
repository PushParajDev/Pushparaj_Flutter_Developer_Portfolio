import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/hover.dart';

/// Section anchors, matching the `#id` targets of the original markup.
enum SectionId {
  home('Home'),
  about('About'),
  skills('Skills'),
  experience('Experience'),
  projects('Projects'),
  services('Services'),
  contact('Contact');

  const SectionId(this.label);
  final String label;
}

const navSections = [
  SectionId.about,
  SectionId.skills,
  SectionId.experience,
  SectionId.projects,
  SectionId.services,
  SectionId.contact,
];

class Navbar extends StatelessWidget {
  const Navbar({
    super.key,
    required this.scrolled,
    required this.active,
    required this.onNavigate,
    required this.onToggleTheme,
    required this.isDark,
    required this.menuOpen,
    required this.onToggleMenu,
  });

  final bool scrolled;
  final SectionId active;
  final void Function(SectionId) onNavigate;
  final VoidCallback onToggleTheme;
  final bool isDark;
  final bool menuOpen;
  final VoidCallback onToggleMenu;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final narrow = context.isNarrow;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: scrolled ? AppTokens.navHeightScrolled : AppTokens.navHeight,
      decoration: BoxDecoration(
        color: scrolled ? t.surfaceGlass : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: scrolled ? t.border : Colors.transparent),
        ),
        boxShadow: scrolled ? t.shadowSm : null,
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: scrolled
              ? ImageFilter.blur(sigmaX: 16, sigmaY: 16)
              : ImageFilter.blur(sigmaX: 0.001, sigmaY: 0.001),
          child: SiteContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Brand(onTap: () => onNavigate(SectionId.home)),
                if (!narrow)
                  Row(
                    children: [
                      for (final s in navSections) ...[
                        _NavLink(
                          label: s.label,
                          active: active == s,
                          onTap: () => onNavigate(s),
                        ),
                        if (s != navSections.last) const SizedBox(width: 34),
                      ],
                    ],
                  ),
                Row(
                  children: [
                    _ThemeToggle(isDark: isDark, onTap: onToggleTheme),
                    const SizedBox(width: 12),
                    if (!narrow)
                      AppButton(
                        label: 'Hire Me',
                        small: true,
                        onPressed: () => onNavigate(SectionId.contact),
                      ),
                    if (narrow) _MenuToggle(open: menuOpen, onTap: onToggleMenu),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Hover(
      onTap: onTap,
      builder: (context, hovered) => Row(
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
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Hover(
      onTap: onTap,
      builder: (context, hovered) {
        final lit = hovered || active;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: lit ? t.ink : t.muted,
                ),
              ),
            ),
            // `.nav-links a::after` — the underline grows from 0 to 100%.
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 2,
              width: lit ? label.length * 8.0 : 0,
              decoration: BoxDecoration(
                gradient: t.brandGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle({required this.isDark, required this.onTap});
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Tooltip(
      message: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      child: Hover(
        onTap: onTap,
        builder: (context, hovered) => AnimatedRotation(
          turns: hovered ? 0.055 : 0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: t.surfaceGlass,
              border: Border.all(color: hovered ? t.primary : t.border),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
                size: 17,
                color: t.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuToggle extends StatelessWidget {
  const _MenuToggle({required this.open, required this.onTap});
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Hover(
      onTap: onTap,
      builder: (context, hovered) => Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTokens.radiusSm),
          border: Border.all(color: t.border),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            open ? Icons.close_rounded : Icons.menu_rounded,
            key: ValueKey(open),
            size: 20,
            color: t.ink,
          ),
        ),
      ),
    );
  }
}

/// The full-screen slide-in menu used below the 940px breakpoint.
class MobileMenu extends StatelessWidget {
  const MobileMenu({
    super.key,
    required this.open,
    required this.onNavigate,
    required this.active,
  });

  final bool open;
  final void Function(SectionId) onNavigate;
  final SectionId active;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return IgnorePointer(
      ignoring: !open,
      child: AnimatedSlide(
        offset: Offset(open ? 0 : 1, 0),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        child: Container(
          color: t.surface,
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final s in navSections)
                Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: Hover(
                    onTap: () => onNavigate(s),
                    builder: (context, hovered) => Text(
                      s.label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: hovered || active == s ? t.primary : t.ink,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              AppButton(
                label: 'Hire Me',
                onPressed: () => onNavigate(SectionId.contact),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
