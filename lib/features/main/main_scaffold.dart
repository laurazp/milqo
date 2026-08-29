import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';

/// Barra inferior con las 4 secciones principales — apartado 3 (Mapa de
/// navegación): siempre visible, permite saltar de sección en cualquier
/// momento; el resto de pantallas se abren apiladas encima con el navigator
/// raíz. Cada rama mantiene su propio estado (go_router's
/// `StatefulShellRoute.indexedStack`), igual que el `IndexedStack` manual
/// que sustituye.
class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(AppConstants.homeIcon), label: 'Inicio'),
          NavigationDestination(icon: Icon(AppConstants.calculatorIcon), label: 'Calculadora'),
          NavigationDestination(icon: Icon(AppConstants.recipesIcon), label: 'Recetas'),
          NavigationDestination(icon: Icon(AppConstants.favoritesIcon), label: 'Favoritos'),
        ],
      ),
    );
  }
}
