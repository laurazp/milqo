import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Signals the Recetas tab to focus its search field — used by the search
/// icon in Home's header (apartado 4.1: "Abre el buscador de recetas").
///
/// A plain counter: Home bumps it and navigates to `/recipes`;
/// [RecipesView] listens and requests focus whenever the value changes,
/// including while it's already the active tab.
class RecipesSearchFocusRequest extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final recipesSearchFocusRequestProvider =
    NotifierProvider<RecipesSearchFocusRequest, int>(RecipesSearchFocusRequest.new);
