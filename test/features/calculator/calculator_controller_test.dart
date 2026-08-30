import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milqo_flutter/data/local/app_data_store.dart';
import 'package:milqo_flutter/data/models/calculator_mode.dart';
import 'package:milqo_flutter/data/models/creaminess.dart';
import 'package:milqo_flutter/features/calculator/calculator_controller.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppDataStore.instance.load();
  });

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('empieza con el ingrediente con el que se entró y los valores por defecto', () {
    final state = container.read(calculatorControllerProvider('avena'));

    expect(state.ingredientId, 'avena');
    expect(state.modo, CalculatorMode.wantMl);
    expect(state.cremosidad, Creaminess.normal);
    expect(state.mlValue, 1000);
  });

  test('cada ingrediente con el que se entra tiene su propio estado independiente', () {
    final avena = container.read(calculatorControllerProvider('avena').notifier);
    avena.setValue(1500);

    expect(container.read(calculatorControllerProvider('avena')).mlValue, 1500);
    // Una instancia distinta (family) para "almendra" no se ve afectada.
    expect(container.read(calculatorControllerProvider('almendra')).mlValue, 1000);
  });

  test('setValue respeta los límites de "Quiero ___ ml" (100-3000)', () {
    final notifier = container.read(calculatorControllerProvider('avena').notifier);

    notifier.setValue(5000);
    expect(container.read(calculatorControllerProvider('avena')).mlValue, 3000);

    notifier.setValue(0);
    expect(container.read(calculatorControllerProvider('avena')).mlValue, 100);
  });

  test('setValue respeta los límites de "Tengo ___ g" (50-500)', () {
    final notifier = container.read(calculatorControllerProvider('avena').notifier);
    notifier.setMode(CalculatorMode.haveGrams);

    notifier.setValue(1000);
    expect(container.read(calculatorControllerProvider('avena')).gramsValue, 500);

    notifier.setValue(0);
    expect(container.read(calculatorControllerProvider('avena')).gramsValue, 50);
  });

  test('increment/decrement usan el paso correcto según el modo (50 ml / 25 g)', () {
    final notifier = container.read(calculatorControllerProvider('avena').notifier);

    notifier.increment();
    expect(container.read(calculatorControllerProvider('avena')).mlValue, 1050);
    notifier.decrement();
    notifier.decrement();
    expect(container.read(calculatorControllerProvider('avena')).mlValue, 950);

    notifier.setMode(CalculatorMode.haveGrams);
    notifier.increment();
    expect(container.read(calculatorControllerProvider('avena')).gramsValue, 225);
  });

  test('cambiar de modo conserva el valor introducido en el otro modo', () {
    final notifier = container.read(calculatorControllerProvider('avena').notifier);

    notifier.setValue(1500);
    notifier.setMode(CalculatorMode.haveGrams);
    notifier.setValue(300);
    notifier.setMode(CalculatorMode.wantMl);

    expect(container.read(calculatorControllerProvider('avena')).mlValue, 1500);
  });

  test('preview refleja el ingrediente, modo y cremosidad actuales', () {
    final notifier = container.read(calculatorControllerProvider('almendra').notifier);
    notifier.setValue(1000);
    notifier.setCreaminess(Creaminess.normal);

    final preview = notifier.preview;

    expect(preview.ingredientId, 'almendra');
    expect(preview.resultadoGramos, 150);
    expect(preview.resultadoMlAgua, 1000);
  });
}
