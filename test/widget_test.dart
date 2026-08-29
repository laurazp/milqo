import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:milqo_flutter/app.dart';
import 'package:milqo_flutter/data/local/app_data_store.dart';

void main() {
  testWidgets('Home screen shows the app name and the 4 bottom tabs', (tester) async {
    await AppDataStore.instance.load();
    await tester.pumpWidget(const ProviderScope(child: MilqoApp()));
    await tester.pumpAndSettle();

    expect(find.text('Milqo'), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Calculadora'), findsOneWidget);
    expect(find.text('Recetas'), findsOneWidget);
    expect(find.text('Favoritos'), findsOneWidget);
  });
}
