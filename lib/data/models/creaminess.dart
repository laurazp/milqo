/// Nivel de cremosidad de la calculadora — apartado 4.3/7 de la especificación.
///
/// El factor se aplica sobre la cantidad de ingrediente sólido, nunca sobre
/// el agua: Ligera = 0.8 · Normal = 1.0 · Cremosa = 1.2.
enum Creaminess {
  ligera(0.8, 'Ligera'),
  normal(1.0, 'Normal'),
  cremosa(1.2, 'Cremosa');

  final double factor;
  final String label;

  const Creaminess(this.factor, this.label);
}
