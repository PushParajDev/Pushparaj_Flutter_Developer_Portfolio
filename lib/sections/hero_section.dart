import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../config/site_config.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_icon.dart';
import '../widgets/float.dart';
import '../widgets/glass_card.dart';
import '../widgets/particles.dart';
import '../widgets/section_head.dart';
import '../widgets/typewriter.dart';
import 'navbar.dart';

/// The `rider_signup_controller.dart` snippet, pre-tokenised for [TypedCode].
const _codeTokens = <CodeToken>[
  CodeToken('class', CodeTokenKind.keyword),
  CodeToken(' ', CodeTokenKind.plain),
  CodeToken('RiderSignupController', CodeTokenKind.type),
  CodeToken(' ', CodeTokenKind.plain),
  CodeToken('extends', CodeTokenKind.keyword),
  CodeToken(' ', CodeTokenKind.plain),
  CodeToken('GetxController', CodeTokenKind.type),
  CodeToken(' {\n  ', CodeTokenKind.plain),
  CodeToken('final', CodeTokenKind.keyword),
  CodeToken(' name = ', CodeTokenKind.plain),
  CodeToken("''", CodeTokenKind.string),
  CodeToken('.', CodeTokenKind.plain),
  CodeToken('obs', CodeTokenKind.keyword),
  CodeToken(';\n  ', CodeTokenKind.plain),
  CodeToken('final', CodeTokenKind.keyword),
  CodeToken(' isLoading = ', CodeTokenKind.plain),
  CodeToken('false', CodeTokenKind.keyword),
  CodeToken('.', CodeTokenKind.plain),
  CodeToken('obs', CodeTokenKind.keyword),
  CodeToken(';\n\n  ', CodeTokenKind.plain),
  CodeToken('// keep state updates out of build()', CodeTokenKind.comment),
  CodeToken('\n  ', CodeTokenKind.plain),
  CodeToken('void', CodeTokenKind.keyword),
  CodeToken(' submit() {\n    isLoading.value = ', CodeTokenKind.plain),
  CodeToken('true', CodeTokenKind.keyword),
  CodeToken(';\n    ', CodeTokenKind.plain),
  CodeToken('ApiClient', CodeTokenKind.type),
  CodeToken('.post(', CodeTokenKind.plain),
  CodeToken("'/riders'", CodeTokenKind.string),
  CodeToken(', data: {\n      ', CodeTokenKind.plain),
  CodeToken("'name'", CodeTokenKind.string),
  CodeToken(': name.value,\n    });\n  }\n}', CodeTokenKind.plain),
];

class HeroSection extends StatefulWidget {
  const HeroSection({super.key, required this.onNavigate});

  final void Function(SectionId) onNavigate;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  // Replaces the GSAP entrance timeline (staggered copy, code window, floats).
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  )..forward();

  Animation<double> _stagger(
    double start,
    double end, {
    Curve curve = Curves.easeOutCubic,
  }) => CurvedAnimation(
    parent: _intro,
    curve: Interval(start, end, curve: curve),
  );

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final narrow = context.isNarrow;
    final screenH = MediaQuery.sizeOf(context).height;

    return Container(
      constraints: BoxConstraints(minHeight: screenH),
      child: Stack(
        children: [
          Positioned.fill(child: MeshBackground(colors: t.meshColors)),
          Positioned.fill(
            child: ParticleField(
              colors: [t.primary, t.accent, t.accent2],
              linkColor: t.primary,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: AppTokens.navHeight + 40,
              bottom: narrow ? 80 : 60,
            ),
            child: SiteContainer(
              child: narrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroCopy(
                          intro: _stagger,
                          onNavigate: widget.onNavigate,
                        ),
                        const SizedBox(height: 40),
                        _HeroVisual(intro: _stagger),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 105,
                          child: _HeroCopy(
                            intro: _stagger,
                            onNavigate: widget.onNavigate,
                          ),
                        ),
                        const SizedBox(width: 60),
                        Expanded(flex: 95, child: _HeroVisual(intro: _stagger)),
                      ],
                    ),
            ),
          ),
          if (!narrow)
            Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Center(child: _ScrollCue()),
            ),
        ],
      ),
    );
  }
}

typedef _Stagger =
    Animation<double> Function(double start, double end, {Curve curve});

/// Fades + lifts a child on a slice of the intro timeline.
class _Intro extends StatelessWidget {
  const _Intro({
    required this.animation,
    required this.child,
    this.dy = 24,
    this.scale,
  });

  final Animation<double> animation;
  final Widget child;
  final double dy;
  final double? scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final v = animation.value;
        return Opacity(
          // Overshoot curves (easeOutBack) push v past 1.0 — keep the bounce on
          // the transform, but Opacity asserts on anything outside 0..1.
          opacity: v.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, dy * (1 - v)),
            child: scale == null
                ? child
                : Transform.scale(
                    scale: scale! + (1 - scale!) * v,
                    child: child,
                  ),
          ),
        );
      },
      child: child,
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.intro, required this.onNavigate});

  final _Stagger intro;
  final void Function(SectionId) onNavigate;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final h1Size = context.clampVw(38, 5.4, 64);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Intro(
          animation: intro(0.15, 0.55),
          child: const Eyebrow('Available for new opportunities'),
        ),
        const SizedBox(height: 22),
        _Intro(
          animation: intro(0.2, 0.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Building smooth, scalable',
                style: display(
                  TextStyle(
                    fontSize: h1Size,
                    fontWeight: FontWeight.w600,
                    height: 1.08,
                    letterSpacing: -1.4,
                    color: t.ink,
                  ),
                ),
              ),
              GradientText(
                'Flutter experiences.',
                gradient: t.brandGradient,
                style: display(
                  TextStyle(
                    fontSize: h1Size,
                    fontWeight: FontWeight.w600,
                    height: 1.12,
                    letterSpacing: -1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _Intro(
          animation: intro(0.28, 0.68),
          child: SizedBox(
            height: 34,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Typewriter(
                strings: SiteConfig.taglineRoles,
                style: mono(
                  TextStyle(
                    fontSize: context.clampVw(16, 2, 21),
                    color: t.muted,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        _Intro(
          animation: intro(0.34, 0.74),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              SiteConfig.summary,
              style: TextStyle(fontSize: 17, height: 1.6, color: t.muted),
            ),
          ),
        ),
        const SizedBox(height: 34),
        _Intro(
          animation: intro(0.42, 0.82),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppButton(
                label: 'Download Resume',
                icon: const AppIconData.material(Icons.download_rounded),
                onPressed: Links.resume,
              ),
              AppButton(
                label: 'Hire Me',
                icon: const AppIconData.material(Icons.send_rounded),
                variant: BtnVariant.outline,
                onPressed: () => onNavigate(SectionId.contact),
              ),
              AppButton(
                label: 'View Projects',
                icon: const AppIconData.material(Icons.folder_open_rounded),
                variant: BtnVariant.ghost,
                onPressed: () => onNavigate(SectionId.projects),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _Intro(animation: intro(0.5, 0.9), child: const SocialRow()),
      ],
    );
  }
}

/// The LinkedIn / GitHub / WhatsApp / Email chip row, reused in the footer.
class SocialRow extends StatelessWidget {
  const SocialRow({super.key, this.size = 42});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SocialChip(
          icon: const AppIconData.fa(FontAwesomeIcons.linkedinIn),
          tooltip: 'LinkedIn',
          size: size,
          onTap: Links.linkedin,
        ),
        // SocialChip(
        //   icon: const AppIconData.fa(FontAwesomeIcons.github),
        //   tooltip: 'GitHub',
        //   size: size,
        //   onTap: Links.github,
        // ),
        SocialChip(
          icon: const AppIconData.fa(FontAwesomeIcons.whatsapp),
          tooltip: 'WhatsApp',
          size: size,
          onTap: Links.whatsapp,
        ),
        SocialChip(
          icon: const AppIconData.material(Icons.mail_outline_rounded),
          tooltip: 'Email',
          size: size,
          onTap: Links.email,
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.intro});

  final _Stagger intro;

  @override
  Widget build(BuildContext context) {
    final narrow = context.isNarrow;
    final mobile = context.isMobile;
    final height = narrow ? 520.0 : 580.0;

    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // --- portrait with the spinning conic ring ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: _Intro(
                animation: intro(0.05, 0.5, curve: Curves.easeOutBack),
                scale: 0.7,
                dy: 0,
                child: const _PhotoOrbit(),
              ),
            ),
          ),

          // --- orbit badges (hidden under 940px, like the CSS) ---
          if (!narrow) ...[
            Positioned(
              top: height * 0.06,
              left: -16,
              child: _Intro(
                animation: intro(0.6, 1.0, curve: Curves.easeOutBack),
                scale: 0.6,
                dy: 0,
                child: const FloatY(
                  delay: Duration(milliseconds: 200),
                  child: _OrbitBadge(
                    icon: Icons.bolt_rounded,
                    label: 'Flutter',
                  ),
                ),
              ),
            ),
            Positioned(
              top: height * 0.44,
              right: -18,
              child: _Intro(
                animation: intro(0.68, 1.0, curve: Curves.easeOutBack),
                scale: 0.6,
                dy: 0,
                child: const FloatY(
                  delay: Duration(milliseconds: 1300),
                  child: _OrbitBadge(
                    icon: Icons.local_fire_department_rounded,
                    label: 'Firebase',
                  ),
                ),
              ),
            ),
          ],

          // --- floating stat cards (hidden on mobile, like the CSS) ---
          if (!mobile) ...[
            Positioned(
              top: height * 0.52,
              left: -8,
              child: _Intro(
                animation: intro(0.55, 0.95, curve: Curves.easeOutBack),
                scale: 0.8,
                dy: 0,
                child: const FloatY(
                  delay: Duration(milliseconds: 400),
                  child: _StatFloat(
                    number: '50+',
                    label: 'REST APIs\nintegrated',
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: height * 0.14,
              right: -4,
              child: _Intro(
                animation: intro(0.62, 1.0, curve: Curves.easeOutBack),
                scale: 0.8,
                dy: 0,
                child: const FloatY(
                  delay: Duration(milliseconds: 1100),
                  child: _StatFloat(
                    number: '10+',
                    label: 'Apps shipped\nto production',
                  ),
                ),
              ),
            ),
          ],

          // --- IDE code window ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: _Intro(
                animation: intro(0.25, 0.72),
                dy: 30,
                child: const _CodeWindow(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoOrbit extends StatelessWidget {
  const _PhotoOrbit();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    const size = 216.0;

    return SizedBox(
      width: size + 18,
      height: size + 18,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SpinningRing(
            size: size + 18,
            holeColor: t.bg,
            colors: [t.primary, t.accent, t.primary600],
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: t.bg, width: 3),
              boxShadow: t.shadowGlow,
            ),
            child: ClipOval(
              child: Image.asset(
                SiteConfig.photo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => ColoredBox(
                  color: t.primary100,
                  child: Center(
                    child: Text(
                      'PP',
                      style: display(
                        TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: t.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitBadge extends StatelessWidget {
  const _OrbitBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return GlassCard(
      radius: 100,
      blur: 10,
      shadow: t.shadowMd,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: t.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: mono(
              TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: t.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatFloat extends StatelessWidget {
  const _StatFloat({required this.number, required this.label});

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return GlassCard(
      radius: AppTokens.radiusMd,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number,
            style: mono(
              TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: t.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontSize: 11.5, height: 1.35, color: t.muted),
          ),
        ],
      ),
    );
  }
}

class _CodeWindow extends StatelessWidget {
  const _CodeWindow();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: SurfaceCard(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // title bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: t.bgSoft,
                  border: Border(bottom: BorderSide(color: t.borderSoft)),
                ),
                child: Row(
                  children: [
                    const _WinDot(Color(0xFFFF5F57)),
                    const SizedBox(width: 8),
                    const _WinDot(Color(0xFFFEBC2E)),
                    const SizedBox(width: 8),
                    const _WinDot(Color(0xFF28C840)),
                    const SizedBox(width: 16),
                    Text(
                      'portfolio_controller.dart',
                      style: mono(TextStyle(fontSize: 12, color: t.muted)),
                    ),
                  ],
                ),
              ),
              // typed source
              // Container(
              //   constraints: const BoxConstraints(minHeight: 210),
              //   padding: const EdgeInsets.all(20),
              //   alignment: Alignment.topLeft,
              //   child: const TypedCode(tokens: _codeTokens),
              // ),
              // terminal strip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: t.bgSoft,
                  border: Border(top: BorderSide(color: t.borderSoft)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r'$ flutter run --release',
                      style: mono(TextStyle(fontSize: 12, color: t.muted)),
                    ),
                    RichText(
                      text: TextSpan(
                        style: mono(TextStyle(fontSize: 12, color: t.muted)),
                        children: [
                          TextSpan(
                            text: '✓ ',
                            style: mono(
                              const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF28C840),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const TextSpan(
                            text: 'Built build/app-release.apk (24.1MB)',
                          ),
                        ],
                      ),
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

class _WinDot extends StatelessWidget {
  const _WinDot(this.color);
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

/// `.scroll-cue` — "SCROLL" over a gradient stick with a running highlight.
class _ScrollCue extends StatefulWidget {
  @override
  State<_ScrollCue> createState() => _ScrollCueState();
}

class _ScrollCueState extends State<_ScrollCue>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'SCROLL',
          style: mono(
            TextStyle(fontSize: 11, color: t.muted, letterSpacing: 1),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 1.5,
          height: 34,
          child: ClipRect(
            child: Stack(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [t.primary, t.primary.withValues(alpha: 0)],
                    ),
                  ),
                  child: const SizedBox.expand(),
                ),
                AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) => Positioned(
                    top: -10 + 44 * _c.value,
                    child: Container(width: 1.5, height: 10, color: t.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
