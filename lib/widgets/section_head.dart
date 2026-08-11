import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/scroll_reveal.dart';
import '../theme/app_theme.dart';
import 'hover.dart';

/// `.eyebrow` — mono, uppercase, .14em tracking, preceded by a 20px rule.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.center = false});

  final String text;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Container(width: 20, height: 1.5, color: t.primary),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: mono(TextStyle(
            fontSize: 12.5,
            letterSpacing: 1.75,
            fontWeight: FontWeight.w600,
            color: t.primary,
          )),
        ),
      ],
    );
  }
}

/// `.section-head.center` — eyebrow + h2 + optional lede, max-width 640px.
class SectionHead extends StatelessWidget {
  const SectionHead({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.center = true,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Reveal(
      child: Container(
        width: double.infinity,
        alignment: center ? Alignment.topCenter : Alignment.topLeft,
        margin: const EdgeInsets.only(bottom: 56),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment:
                center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Eyebrow(eyebrow, center: center),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: center ? TextAlign.center : TextAlign.start,
                style: display(TextStyle(
                  fontSize: context.clampVw(30, 4, 44),
                  fontWeight: FontWeight.w600,
                  height: 1.08,
                  letterSpacing: -0.9,
                  color: t.ink,
                )),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 14),
                Text(
                  subtitle!,
                  textAlign: center ? TextAlign.center : TextAlign.start,
                  style: TextStyle(fontSize: 17, height: 1.6, color: t.muted),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// `.chip` — mono pill used for the domain list.
class DomainChip extends StatelessWidget {
  const DomainChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Hover(
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: hovered ? t.primary : t.border),
        ),
        child: Text(
          label,
          style: mono(TextStyle(
            fontSize: 12.5,
            color: hovered ? t.primary : t.muted,
          )),
        ),
      ),
    );
  }
}

/// `.tech-tags span` — small mono chip on a soft background.
class TechTag extends StatelessWidget {
  const TechTag(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: t.bgSoft,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: mono(TextStyle(fontSize: 11, color: t.muted))),
    );
  }
}
