import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'hover.dart';

enum BtnVariant { primary, outline, ghost }

/// `.btn` / `.btn-primary` / `.btn-outline` / `.btn-ghost` (+ `.btn-sm`).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = BtnVariant.primary,
    this.small = false,
    this.onLight = true,
  });

  final String label;
  final AppIconData? icon;
  final VoidCallback? onPressed;
  final BtnVariant variant;
  final bool small;

  /// `false` inside the gradient CTA band, where the palette inverts.
  final bool onLight;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final pad = small
        ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 26, vertical: 14);
    final fontSize = small ? 13.0 : 14.5;

    return Hover(
      onTap: onPressed,
      duration: const Duration(milliseconds: 250),
      builder: (context, hovered) {
        Color fg;
        Color? bg;
        Gradient? gradient;
        BoxBorder? border;
        List<BoxShadow>? shadow;
        var blur = false;

        switch (variant) {
          case BtnVariant.primary:
            if (onLight) {
              gradient = t.brandGradient;
              fg = Colors.white;
              shadow = hovered
                  ? [BoxShadow(color: t.primary.withValues(alpha: .30), blurRadius: 60, offset: const Offset(0, 26))]
                  : t.shadowGlow;
            } else {
              bg = Colors.white;
              fg = t.primary600;
              shadow = [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .2),
                  blurRadius: 50,
                  offset: const Offset(0, 20),
                ),
              ];
            }
          case BtnVariant.outline:
            fg = onLight ? (hovered ? t.primary : t.ink) : Colors.white;
            bg = onLight
                ? Colors.transparent
                : (hovered ? Colors.white.withValues(alpha: .14) : Colors.transparent);
            border = Border.all(
              color: onLight
                  ? (hovered ? t.primary : t.border)
                  : (hovered ? Colors.white : Colors.white.withValues(alpha: .5)),
              width: 1.5,
            );
          case BtnVariant.ghost:
            fg = t.ink;
            bg = t.surfaceGlass;
            border = Border.all(color: hovered ? t.primary : t.border);
            blur = true;
        }

        final content = AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: const Cubic(.2, .8, .2, 1),
          transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
          padding: pad,
          decoration: BoxDecoration(
            color: bg,
            gradient: gradient,
            border: border,
            borderRadius: BorderRadius.circular(100),
            boxShadow: shadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                AppIcon(icon!, size: 15, color: fg),
                const SizedBox(width: 9),
              ],
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        );

        if (!blur) return content;
        return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: content,
          ),
        );
      },
    );
  }
}

/// `.social-chip` — 42px round icon button that lifts and tints on hover.
class SocialChip extends StatelessWidget {
  const SocialChip({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.size = 42,
  });

  final AppIconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Tooltip(
      message: tooltip,
      child: Hover(
        onTap: onTap,
        duration: const Duration(milliseconds: 250),
        builder: (context, hovered) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: size,
          height: size,
          transform: Matrix4.translationValues(0, hovered ? -3 : 0, 0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: t.surfaceGlass,
            border: Border.all(color: hovered ? t.primary : t.border),
            boxShadow: hovered ? t.shadowMd : null,
          ),
          child: AppIcon(icon, size: size * 0.4, color: hovered ? t.primary : t.ink),
        ),
      ),
    );
  }
}

/// `.icon-link` — 34px rounded-square icon used on project cards.
class IconLinkBox extends StatelessWidget {
  const IconLinkBox({super.key, required this.icon, this.tooltip, this.onTap});

  final AppIconData icon;
  final String? tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final box = Hover(
      onTap: onTap,
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTokens.radiusSm),
          border: Border.all(color: hovered ? t.primary : t.border),
        ),
        child: AppIcon(icon, size: 13, color: hovered ? t.primary : t.muted),
      ),
    );
    return tooltip == null ? box : Tooltip(message: tooltip!, child: box);
  }
}
