import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/usecases/convert_units_usecase.dart';

/// Estado del Conversor de unidades — apartado 4.9.
class ConverterState {
  final String ingredientId;
  final ConvertibleUnit fromUnit;
  final ConvertibleUnit toUnit;
  final double inputValue;

  const ConverterState({
    required this.ingredientId,
    this.fromUnit = ConvertibleUnit.gramos,
    this.toUnit = ConvertibleUnit.tazas,
    this.inputValue = 100,
  });

  ConverterState copyWith({
    String? ingredientId,
    ConvertibleUnit? fromUnit,
    ConvertibleUnit? toUnit,
    double? inputValue,
  }) {
    return ConverterState(
      ingredientId: ingredientId ?? this.ingredientId,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      inputValue: inputValue ?? this.inputValue,
    );
  }
}

/// Controla el Conversor, keyed por el ingrediente con el que se entró a la
/// pantalla — recibido por el constructor (ver nota en
/// `CalculatorController`) y `autoDispose` porque su estado solo importa
/// mientras esa pantalla está en pantalla.
class ConverterController extends Notifier<ConverterState> {
  final String initialIngredientId;

  ConverterController(this.initialIngredientId);

  @override
  ConverterState build() => ConverterState(ingredientId: initialIngredientId);

  void setIngredient(String id) => state = state.copyWith(ingredientId: id);

  void setFromUnit(ConvertibleUnit unit) => state = state.copyWith(fromUnit: unit);

  void setToUnit(ConvertibleUnit unit) => state = state.copyWith(toUnit: unit);

  void setInputValue(double value) => state = state.copyWith(inputValue: value);

  double get outputValue => ref.read(convertUnitsUseCaseProvider).convert(
        ingredientId: state.ingredientId,
        value: state.inputValue,
        from: state.fromUnit,
        to: state.toUnit,
      );

  void swap() {
    final newInput = outputValue;
    state = state.copyWith(
      fromUnit: state.toUnit,
      toUnit: state.fromUnit,
      inputValue: newInput,
    );
  }
}

final converterControllerProvider = NotifierProvider.autoDispose
    .family<ConverterController, ConverterState, String>(ConverterController.new);
