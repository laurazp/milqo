import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/calculator/calculator_view.dart';
import '../../features/converter/converter_view.dart';
import '../../features/favorites/favorites_view.dart';
import '../../features/home/home_view.dart';
import '../../features/ingredient_selection/ingredient_selection_view.dart';
import '../../features/main/main_scaffold.dart';
import '../../features/recipe_detail/recipe_detail_view.dart';
import '../../features/recipe_scale/recipe_scale_view.dart';
import '../../features/recipes/recipes_view.dart';
import '../../features/result/result_view.dart';
import 'app_routes.dart';

/// Permite mostrar un SnackBar después de una navegación que ya ha
/// desmontado la pantalla que lo dispara — apartado 4.8, "Guardar receta
/// escalada" (confirmación en Favoritos).
///
/// Scoped as a provider (not a bare top-level `final`) so every
/// [ProviderScope] gets its own key: reusing the same [GlobalKey] — or the
/// router below — across two separate widget-tree mounts (e.g. two
/// `testWidgets` in the same file, each with its own `MilqoApp`) makes the
/// second mount hang indefinitely instead of settling.
final scaffoldMessengerKeyProvider =
    Provider<GlobalKey<ScaffoldMessengerState>>((ref) => GlobalKey<ScaffoldMessengerState>());

/// Rutas — apartado 3 (Mapa de navegación). Inicio, Calculadora, Recetas y
/// Favoritos son las 4 ramas de la barra inferior, siempre visible; el
/// resto de pantallas se apilan encima con el navigator raíz, sin barra.
final appRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final homeNavigatorKey = GlobalKey<NavigatorState>();
  final calculatorNavigatorKey = GlobalKey<NavigatorState>();
  final recipesNavigatorKey = GlobalKey<NavigatorState>();
  final favoritesNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(navigatorKey: homeNavigatorKey, routes: [
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (context, state) => const NoTransitionPage(child: HomeView()),
            ),
          ]),
          StatefulShellBranch(navigatorKey: calculatorNavigatorKey, routes: [
            GoRoute(
              path: AppRoutes.calculatorTab,
              pageBuilder: (context, state) => const NoTransitionPage(child: CalculatorView()),
            ),
          ]),
          StatefulShellBranch(navigatorKey: recipesNavigatorKey, routes: [
            GoRoute(
              path: AppRoutes.recipesTab,
              pageBuilder: (context, state) => const NoTransitionPage(child: RecipesView()),
            ),
          ]),
          StatefulShellBranch(navigatorKey: favoritesNavigatorKey, routes: [
            GoRoute(
              path: AppRoutes.favoritesTab,
              pageBuilder: (context, state) => const NoTransitionPage(child: FavoritesView()),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: AppRoutes.selection,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const IngredientSelectionView(),
      ),
      GoRoute(
        path: '${AppRoutes.calculatorTab}/:ingredientId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => CalculatorView(ingredientId: state.pathParameters['ingredientId']),
      ),
      GoRoute(
        path: AppRoutes.result,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra as ResultRouteArgs;
          return ResultView(result: args.result, initialSavedId: args.initialSavedId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.recipesTab}/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => RecipeDetailView(recipeId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'scale',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => RecipeScaleView(recipeId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.converter,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ConverterView(ingredientId: state.uri.queryParameters['ingredientId']),
      ),
    ],
  );
});
