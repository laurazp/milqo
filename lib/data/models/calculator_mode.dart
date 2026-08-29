/// Los dos modos de entrada de la Calculadora — apartados 4.3 y 4.4.
enum CalculatorMode {
  wantMl('quiero_ml'),
  haveGrams('tengo_gramos');

  final String storageValue;

  const CalculatorMode(this.storageValue);
}
