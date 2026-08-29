/// Unidad de un ingrediente de receta que puede escalarse numéricamente
/// (apartado 7 — reglas de redondeo). `otro` cubre cantidades no numéricas
/// como "Pizca" o "al gusto", que no se recalculan al escalar.
enum RecipeUnit { gramos, mililitros, cucharadita, cucharada, otro }

/// Un ingrediente dentro de una [Recipe], con su cantidad para la receta
/// base (1 L).
class RecipeIngredientItem {
  /// Texto tal cual aparece en la receta base, p. ej. "150 g de copos de avena".
  final String textoOriginal;

  /// Nombre del ingrediente sin cantidad, p. ej. "copos de avena", usado para
  /// reconstruir el texto al escalar la receta.
  final String nombre;

  /// Cantidad numérica en la receta base, o null si no es escalable.
  final double? cantidadBase;
  final RecipeUnit unidad;
  final bool esOpcional;

  const RecipeIngredientItem({
    required this.textoOriginal,
    required this.nombre,
    this.cantidadBase,
    this.unidad = RecipeUnit.otro,
    this.esOpcional = false,
  });

  factory RecipeIngredientItem.fromJson(Map<String, dynamic> json) => RecipeIngredientItem(
        textoOriginal: json['textoOriginal'] as String,
        nombre: json['nombre'] as String,
        cantidadBase: (json['cantidadBase'] as num?)?.toDouble(),
        unidad: RecipeUnit.values.firstWhere((u) => u.name == json['unidad']),
        esOpcional: json['esOpcional'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'textoOriginal': textoOriginal,
        'nombre': nombre,
        'cantidadBase': cantidadBase,
        'unidad': unidad.name,
        'esOpcional': esOpcional,
      };
}

/// Receta completa — apartado 4.7 y 8 de la especificación. Todas las
/// recetas de la v1 rinden 1 L en su versión base.
class Recipe {
  final String id;
  final String ingredientId;
  final String nombre;
  final String tiempoRemojo;
  final String tiempoPreparacion;
  final double rindeMl;
  final List<RecipeIngredientItem> ingredientes;
  final List<String> pasos;

  /// Fuentes en las que se inspira la receta, para la línea de atribución
  /// "Inspirada en varias recetas de [fuente A] y [fuente B]" y el enlace
  /// "Ver receta original".
  final List<String> fuentesNombres;
  final String fuenteUrl;

  const Recipe({
    required this.id,
    required this.ingredientId,
    required this.nombre,
    required this.tiempoRemojo,
    required this.tiempoPreparacion,
    this.rindeMl = 1000,
    required this.ingredientes,
    required this.pasos,
    required this.fuentesNombres,
    required this.fuenteUrl,
  });

  double get rindeLitros => rindeMl / 1000;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String,
        ingredientId: json['ingredientId'] as String,
        nombre: json['nombre'] as String,
        tiempoRemojo: json['tiempoRemojo'] as String,
        tiempoPreparacion: json['tiempoPreparacion'] as String,
        rindeMl: (json['rindeMl'] as num).toDouble(),
        ingredientes: (json['ingredientes'] as List)
            .map((i) => RecipeIngredientItem.fromJson(i as Map<String, dynamic>))
            .toList(),
        pasos: (json['pasos'] as List).cast<String>(),
        fuentesNombres: (json['fuentesNombres'] as List).cast<String>(),
        fuenteUrl: json['fuenteUrl'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ingredientId': ingredientId,
        'nombre': nombre,
        'tiempoRemojo': tiempoRemojo,
        'tiempoPreparacion': tiempoPreparacion,
        'rindeMl': rindeMl,
        'ingredientes': ingredientes.map((i) => i.toJson()).toList(),
        'pasos': pasos,
        'fuentesNombres': fuentesNombres,
        'fuenteUrl': fuenteUrl,
      };
}
