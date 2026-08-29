/// Confianza de un [Ratio] según cuánto coinciden las fuentes consultadas
/// entre sí — columna "Confianza" del apartado 6 de la especificación.
enum RatioConfidence {
  alta('Alta'),
  mediaAlta('Media-Alta'),
  media('Media');

  final String label;

  const RatioConfidence(this.label);
}
