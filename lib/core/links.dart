import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/site_config.dart';

/// Thin wrapper around url_launcher so section widgets stay declarative.
class Links {
  const Links._();

  static Future<void> open(String url) async {
    if (url.isEmpty || url == '#') return;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  static Future<void> phone() =>
      open('tel:${SiteConfig.phone.replaceAll(' ', '')}');
  static Future<void> email() => open('mailto:${SiteConfig.email}');
  static Future<void> whatsapp() =>
      open('https://wa.me/${SiteConfig.whatsapp}');
  static Future<void> linkedin() => open(SiteConfig.linkedin);
  static Future<void> github() => open(SiteConfig.github);

  /// The resume ships as a bundled asset, so it resolves under `assets/` on the
  /// deployed web build.
  static Future<void> resume() => open('${SiteConfig.resumeFile}');
}
