import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:milqo_flutter/app.dart';
import 'package:milqo_flutter/data/local/app_data_store.dart';

/// Pumps a bounded number of frames instead of `pumpAndSettle()`, which can
/// hang forever if anything in the tree keeps scheduling new frames.
/// 3 simulated seconds is plenty for navigation transitions and the
/// initial async provider loads to finish.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 60; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUpAll(() {
    // AppTheme pulls Poppins/Inter via google_fonts, which otherwise tries
    // to fetch font files over the network the first time a given
    // weight/style is used — not safe to rely on in a sandboxed test
    // environment with no egress.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Home screen shows the app name and the 4 bottom tabs', (tester) async {
    await AppDataStore.instance.load();
    await tester.pumpWidget(const ProviderScope(child: MilqoApp()));
    await _settle(tester);

    expect(find.text('Milqo'), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Calculadora'), findsOneWidget);
    expect(find.text('Recetas'), findsOneWidget);
    expect(find.text('Favoritos'), findsOneWidget);
  });

  testWidgets('Home -> acceso rápido a Avena -> Calcular receta -> Resultado correcto', (tester) async {
    await AppDataStore.instance.load();
    await tester.pumpWidget(const ProviderScope(child: MilqoApp()));
    await _settle(tester);

    await tester.tap(find.text('Avena'));
    await _settle(tester);

    expect(find.text('Calculadora'), findsOneWidget);
    expect(find.text('Avena'), findsWidgets);

    await tester.tap(find.text('Calcular receta'));
    await _settle(tester);

    expect(find.text('Resultado'), findsOneWidget);
    // 1000 ml por defecto, ratio base de la avena (150 g/L), cremosidad
    // normal, con pérdida por colado (apartado 7): 150 g / 1000 ml / ≈925 ml.
    expect(find.text('150 g'), findsOneWidget);
    expect(find.text('1000 ml'), findsOneWidget);
    expect(find.text('≈ 925 ml'), findsOneWidget);
  });
}
