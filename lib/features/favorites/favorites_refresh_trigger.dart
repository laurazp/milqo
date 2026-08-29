import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bumped by any screen that adds/removes a favorite or a saved calculation
/// (Resultado, Detalle de receta, Recetas, Escalado de receta). Favoritos
/// stays mounted (its tab's `Navigator` is preserved by the shell route)
/// even while another tab is active, so it can't just reload in `initState`
/// — [FavoritesController.build] watches this instead, to reload whenever
/// something elsewhere actually changed.
class FavoritesRefreshTrigger extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final favoritesRefreshTriggerProvider =
    NotifierProvider<FavoritesRefreshTrigger, int>(FavoritesRefreshTrigger.new);
