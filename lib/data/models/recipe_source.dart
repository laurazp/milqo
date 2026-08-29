/// Fuente externa (blog/web) en la que se basa un [Ratio] o una receta.
class RecipeSource {
  final String nombre;
  final String url;

  const RecipeSource({required this.nombre, required this.url});

  factory RecipeSource.fromJson(Map<String, dynamic> json) => RecipeSource(
        nombre: json['nombre'] as String,
        url: json['url'] as String,
      );

  Map<String, dynamic> toJson() => {'nombre': nombre, 'url': url};
}
