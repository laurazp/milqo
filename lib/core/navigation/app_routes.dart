/// Rutas de la app — apartado 3 (Mapa de navegación). Las 4 secciones
/// principales (Inicio, Calculadora, Recetas, Favoritos) son las ramas del
/// `StatefulShellRoute` de la barra inferior; el resto se apila encima con
/// el navigator raíz.
abstract class AppRoutes {
  static const String home = '/';
  static const String calculatorTab = '/calculator';
  static const String recipesTab = '/recipes';
  static const String favoritesTab = '/favorites';

  static const String selection = '/selection';
  static const String result = '/result';
  static const String converter = '/converter';

  static String calculatorFor(String ingredientId) => '/calculator/$ingredientId';
  static String recipeDetail(String recipeId) => '/recipes/$recipeId';
  static String recipeScale(String recipeId) => '/recipes/$recipeId/scale';
  static String converterFor(String ingredientId) => '/converter?ingredientId=$ingredientId';
}
