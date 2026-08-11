import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens ported 1:1 from `css/style.css` `:root` / `[data-theme="dark"]`.
///
/// Read them anywhere with `context.tokens`.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.bg,
    required this.bgSoft,
    required this.surface,
    required this.surfaceGlass,
    required this.ink,
    required this.muted,
    required this.muted2,
    required this.border,
    required this.borderSoft,
    required this.primary,
    required this.primary600,
    required this.primary100,
    required this.accent,
    required this.accent2,
    required this.meshColors,
    required this.shadowSm,
    required this.shadowMd,
    required this.shadowLg,
    required this.shadowGlow,
    required this.isDark,
  });

  final Color bg;
  final Color bgSoft;
  final Color surface;
  final Color surfaceGlass;
  final Color ink;
  final Color muted;
  final Color muted2;
  final Color border;
  final Color borderSoft;

  final Color primary;
  final Color primary600;
  final Color primary100;
  final Color accent;
  final Color accent2;

  /// The three radial-gradient tints of `--gradient-mesh`.
  final List<Color> meshColors;

  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadowMd;
  final List<BoxShadow> shadowLg;
  final List<BoxShadow> shadowGlow;

  final bool isDark;

  /// `--gradient-brand: linear-gradient(135deg, primary 0%, accent 100%)`
  LinearGradient get brandGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary, accent],
      );

  // ---- radii (--radius-sm … --radius-xl) ----
  static const double radiusSm = 10;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusXl = 32;

  // ---- layout ----
  static const double containerWidth = 1180;
  static const double navHeight = 76;
  static const double navHeightScrolled = 64;

  static const AppTokens light = AppTokens(
    bg: Color(0xFFF4F8FE),
    bgSoft: Color(0xFFEBF2FC),
    surface: Color(0xFFFFFFFF),
    surfaceGlass: Color(0x9EFFFFFF), // rgba(255,255,255,.62)
    ink: Color(0xFF0A1830),
    muted: Color(0xFF57668A),
    muted2: Color(0xFF7C89A8),
    border: Color(0x1A0E234A), // rgba(14,35,74,.10)
    borderSoft: Color(0x0F0E234A), // rgba(14,35,74,.06)
    primary: Color(0xFF2A5EE8),
    primary600: Color(0xFF1C46C4),
    primary100: Color(0xFFE4ECFE),
    accent: Color(0xFF12B8E0),
    accent2: Color(0xFF6E5CF0),
    meshColors: [Color(0x242A5EE8), Color(0x2412B8E0), Color(0x1A6E5CF0)],
    shadowSm: [BoxShadow(color: Color(0x0F0A1830), blurRadius: 2, offset: Offset(0, 1))],
    shadowMd: [BoxShadow(color: Color(0x140A1830), blurRadius: 24, offset: Offset(0, 8))],
    shadowLg: [BoxShadow(color: Color(0x240A1830), blurRadius: 64, offset: Offset(0, 24))],
    shadowGlow: [BoxShadow(color: Color(0x292A5EE8), blurRadius: 50, offset: Offset(0, 20))],
    isDark: false,
  );

  static const AppTokens dark = AppTokens(
    bg: Color(0xFF060B16),
    bgSoft: Color(0xFF0A1120),
    surface: Color(0xFF0E1626),
    surfaceGlass: Color(0x8C0E1626), // rgba(14,22,38,.55)
    ink: Color(0xFFEAF1FF),
    muted: Color(0xFF9AABCC),
    muted2: Color(0xFF6E7EA0),
    border: Color(0x17FFFFFF), // rgba(255,255,255,.09)
    borderSoft: Color(0x0DFFFFFF), // rgba(255,255,255,.05)
    primary: Color(0xFF5B8CFF),
    primary600: Color(0xFF7BA1FF),
    primary100: Color(0xFF142244),
    accent: Color(0xFF2FD8FF),
    accent2: Color(0xFF9C8CFF),
    meshColors: [Color(0x2E5B8CFF), Color(0x292FD8FF), Color(0x249C8CFF)],
    shadowSm: [BoxShadow(color: Color(0x4D000000), blurRadius: 2, offset: Offset(0, 1))],
    shadowMd: [BoxShadow(color: Color(0x59000000), blurRadius: 24, offset: Offset(0, 8))],
    shadowLg: [BoxShadow(color: Color(0x80000000), blurRadius: 64, offset: Offset(0, 24))],
    shadowGlow: [BoxShadow(color: Color(0x385B8CFF), blurRadius: 60, offset: Offset(0, 20))],
    isDark: true,
  );

  @override
  AppTokens copyWith() => this;

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      bg: Color.lerp(bg, other.bg, t)!,
      bgSoft: Color.lerp(bgSoft, other.bgSoft, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceGlass: Color.lerp(surfaceGlass, other.surfaceGlass, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      muted2: Color.lerp(muted2, other.muted2, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSoft: Color.lerp(borderSoft, other.borderSoft, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primary600: Color.lerp(primary600, other.primary600, t)!,
      primary100: Color.lerp(primary100, other.primary100, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accent2: Color.lerp(accent2, other.accent2, t)!,
      meshColors: [
        for (var i = 0; i < meshColors.length; i++)
          Color.lerp(meshColors[i], other.meshColors[i], t)!,
      ],
      shadowSm: BoxShadow.lerpList(shadowSm, other.shadowSm, t)!,
      shadowMd: BoxShadow.lerpList(shadowMd, other.shadowMd, t)!,
      shadowLg: BoxShadow.lerpList(shadowLg, other.shadowLg, t)!,
      shadowGlow: BoxShadow.lerpList(shadowGlow, other.shadowGlow, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

extension AppTokensX on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
}

/// `--font-display: 'Space Grotesk'`
TextStyle display(TextStyle base) => GoogleFonts.spaceGrotesk(textStyle: base);

/// `--font-body: 'Inter'`
TextStyle body(TextStyle base) => GoogleFonts.inter(textStyle: base);

/// `--font-mono: 'JetBrains Mono'`
TextStyle mono(TextStyle base) => GoogleFonts.jetBrainsMono(textStyle: base);

ThemeData buildAppTheme(AppTokens t) {
  final base = t.isDark ? ThemeData.dark() : ThemeData.light();

  return base.copyWith(
    extensions: [t],
    scaffoldBackgroundColor: t.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: t.primary,
      brightness: t.isDark ? Brightness.dark : Brightness.light,
    ).copyWith(surface: t.surface, primary: t.primary),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: t.primary,
      cursorColor: t.primary,
    ),
    // Body text = Inter 16px / 1.6, headings = Space Grotesk with -0.02em tracking.
    textTheme: GoogleFonts.interTextTheme(base.textTheme)
        .apply(bodyColor: t.ink, displayColor: t.ink)
        .copyWith(
          displayLarge: display(TextStyle(color: t.ink, fontWeight: FontWeight.w600, height: 1.08, letterSpacing: -1.2)),
          displayMedium: display(TextStyle(color: t.ink, fontWeight: FontWeight.w600, height: 1.08, letterSpacing: -0.9)),
          headlineLarge: display(TextStyle(color: t.ink, fontWeight: FontWeight.w600, height: 1.12, letterSpacing: -0.7)),
          headlineSmall: display(TextStyle(color: t.ink, fontWeight: FontWeight.w600, height: 1.2, letterSpacing: -0.4)),
          titleMedium: display(TextStyle(color: t.ink, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: -0.2)),
          bodyLarge: TextStyle(color: t.ink, fontSize: 16, height: 1.6),
          bodyMedium: TextStyle(color: t.muted, fontSize: 15, height: 1.6),
        ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.hovered) ? t.primary : t.border,
      ),
      thickness: const WidgetStatePropertyAll(10),
      radius: const Radius.circular(10),
    ),
  );
}
