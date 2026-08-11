import 'package:flutter/material.dart';

import '../core/links.dart';
import '../core/responsive.dart';
import '../core/scroll_reveal.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/particles.dart';
import 'navbar.dart';

/// `.availability` — the gradient CTA band above the contact section.
class AvailabilitySection extends StatelessWidget {
  const AvailabilitySection({super.key, required this.onNavigate});

  final void Function(SectionId) onNavigate;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final mobile = context.isMobile;

    return Section(
      topPadding: 0,
      child: Reveal(
        anim: RevealAnim.zoomIn,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTokens.radiusXl),
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: t.brandGradient),
            child: Stack(
              children: [
                Positioned.fill(
                  child: MeshBackground(colors: t.meshColors, opacity: 0.5),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mobile ? 26 : 56,
                    vertical: mobile ? 44 : 64,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const _PulseDot(),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              'Available for New Opportunities',
                              textAlign: TextAlign.center,
                              style: display(TextStyle(
                                fontSize: context.clampVw(26, 3.6, 38),
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                                letterSpacing: -0.8,
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Text(
                          'Open to full-time Flutter Developer roles, freelance projects, '
                          'contract work, startup collaborations and remote engagements.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.5,
                            height: 1.6,
                            color: Colors.white.withValues(alpha: .92),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          AppButton(
                            label: 'Hire Me',
                            onLight: false,
                            onPressed: () => onNavigate(SectionId.contact),
                          ),
                          AppButton(
                            label: "Let's Talk",
                            variant: BtnVariant.outline,
                            onLight: false,
                            onPressed: () => onNavigate(SectionId.contact),
                          ),
                          AppButton(
                            label: 'Download Resume',
                            variant: BtnVariant.outline,
                            onLight: false,
                            onPressed: Links.resume,
                          ),
                        ],
                      ),
                    ],
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

/// `.pulse-dot` — green dot with an expanding halo.
class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
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
    const dot = Color(0xFF5CFFB0);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final v = Curves.easeOut.transform(_c.value);
        return SizedBox(
          width: 9,
          height: 9,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 9 + 24 * v,
                height: 9 + 24 * v,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dot.withValues(alpha: 0.6 * (1 - v)),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, color: dot),
                child: SizedBox(width: 9, height: 9),
              ),
            ],
          ),
        );
      },
    );
  }
}
