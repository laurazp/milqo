import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/calculation_result.dart';
import '../../data/models/calculator_mode.dart';
import '../../data/models/creaminess.dart';

/// Estado de la Calculadora — apartados 4.3 y 4.4.
class CalculatorState {
  static const double wantMlMin = 100, wantMlMax = 3000, wantMlStep = 50;
  static const double haveGramsMin = 50, haveGramsMax = 500, haveGramsStep = 25;

  final String ingredientId;
  final CalculatorMode modo;
  final Creaminess cremosidad;
  final double mlValue;
  final double gramsValue;

  const CalculatorState({
    required this.ingredientId,
    this.modo = CalculatorMode.wantMl,
    this.cremosidad = Creaminess.normal,
    this.mlValue = 1000,
    this.gramsValue = 200,
  });

  double get currentValue => modo == CalculatorMode.wantMl ? mlValue : gramsValue;

  CalculatorState copyWith({
    String? ingredientId,
    CalculatorMode? modo,
    Creaminess? cremosidad,
    double? mlValue,
    double? gramsValue,
  }) {
    return CalculatorState(
      ingredientId: ingredientId ?? this.ingredientId,
      modo: modo ?? this.modo,
      cremosidad: cremosidad ?? this.cremosidad,
      mlValue: mlValue ?? this.mlValue,
      gramsValue: gramsValue ?? this.gramsValue,
    );
  }
}

/// Controla el formulario de la Calculadora, keyed por el ingrediente con el
/// que se entró a la pantalla — recibido por el constructor (Riverpod 3.x:
/// el argumento de una familia se pasa a `create`, no a `build()`) y
/// `autoDispose` porque su estado solo importa mientras esa pantalla está en
/// pantalla.
class CalculatorController extends Notifier<CalculatorState> {
  final String initialIngredientId;

  CalculatorController(this.initialIngredientId);

  @override
  CalculatorState build() => CalculatorState(ingredientId: initialIngredientId);

  void setIngredient(String id) => state = state.copyWith(ingredientId: id);

  void setMode(CalculatorMode mode) => state = state.copyWith(modo: mode);

  void setCreaminess(Creaminess creaminess) => state = state.copyWith(cremosidad: creaminess);

  void setValue(double value) {
    if (state.modo == CalculatorMode.wantMl) {
      state = state.copyWith(
        mlValue: value.clamp(CalculatorState.wantMlMin, CalculatorState.wantMlMax),
      );
    } else {
      state = state.copyWith(
        gramsValue: value.clamp(CalculatorState.haveGramsMin, CalculatorState.haveGramsMax),
      );
    }
  }

  void increment() {
    final step = state.modo == CalculatorMode.wantMl
        ? CalculatorState.wantMlStep
        : CalculatorState.haveGramsStep;
    setValue(state.currentValue + step);
  }

  void decrement() {
    final step = state.modo == CalculatorMode.wantMl
        ? CalculatorState.wantMlStep
        : CalculatorState.haveGramsStep;
    setValue(state.currentValue - step);
  }

  /// Resultado en vivo, usado tanto para el mensaje de rendimiento estimado
  /// de "Tengo X gramos" como para el resultado final al pulsar "Calcular
  /// receta".
  CalculationResult get preview => ref.read(calculateRecipeUseCaseProvider).calculate(
        ingredientId: state.ingredientId,
        modo: state.modo,
        valorInput: state.currentValue,
        cremosidad: state.cremosidad,
      );
}

final calculatorControllerProvider = NotifierProvider.autoDispose
    .family<CalculatorController, CalculatorState, String>(CalculatorController.new);
