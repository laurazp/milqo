/// Tipo de elemento guardado en Favoritos — apartado 4.10 / 5.
enum FavoriteType { receta, calculo }

/// Entrada de Favoritos: referencia a una receta o a un cálculo guardado.
class Favorite {
  final String id;
  final FavoriteType tipo;
  final String referenciaId;
  final DateTime fechaGuardado;

  const Favorite({
    required this.id,
    required this.tipo,
    required this.referenciaId,
    required this.fechaGuardado,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo': tipo.name,
        'referenciaId': referenciaId,
        'fechaGuardado': fechaGuardado.toIso8601String(),
      };

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json['id'] as String,
        tipo: FavoriteType.values.firstWhere((t) => t.name == json['tipo']),
        referenciaId: json['referenciaId'] as String,
        fechaGuardado: DateTime.parse(json['fechaGuardado'] as String),
      );
}
