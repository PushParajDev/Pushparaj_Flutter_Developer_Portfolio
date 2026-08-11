import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio/main.dart';
import 'package:portfolio/theme/theme_controller.dart';

void main() {
  testWidgets('renders the hero headline', (tester) async {
    await tester.pumpWidget(PortfolioApp(themeController: ThemeController()));
    await tester.pump();

    expect(find.text('Building smooth, scalable'), findsOneWidget);
    expect(find.text('Flutter experiences.'), findsOneWidget);
  });
}
