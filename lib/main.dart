import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'config/site_config.dart';
import 'pages/portfolio_page.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'widgets/cursor_fx.dart';
import 'widgets/preloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final theme = ThemeController();
  await theme.load();
  runApp(PortfolioApp(themeController: theme));
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: themeController,
      child: AnimatedBuilder(
        animation: themeController,
        builder: (context, _) => MaterialApp(
          title: '${SiteConfig.name} — ${SiteConfig.role}',
          debugShowCheckedModeBanner: false,
          themeMode: themeController.mode,
          theme: buildAppTheme(AppTokens.light),
          darkTheme: buildAppTheme(AppTokens.dark),
          // `transition: background .4s ease` on <body>
          themeAnimationDuration: const Duration(milliseconds: 400),
          scrollBehavior: const _WebScrollBehavior(),
          builder: (context, child) => CursorFxOverlay(
            child: Preloader(child: child ?? const SizedBox.shrink()),
          ),
          home: const PortfolioPage(),
        ),
      ),
    );
  }
}

/// Lets the page be dragged with a mouse as well as scrolled with the wheel.
class _WebScrollBehavior extends MaterialScrollBehavior {
  const _WebScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
