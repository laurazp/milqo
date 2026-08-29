import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/favorite.dart';

/// Recetas y cálculos guardados en Favoritos — apartado 4.10. Almacenamiento
/// local en la v1, sin cuenta de usuario ni sincronización en la nube.
class FavoritesRepository {
  static const _prefsKey = 'milqo_favorites';

  Future<List<Favorite>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = List<String>.from(prefs.getStringList(_prefsKey) ?? const []);
    return raw
        .map((s) => Favorite.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.fechaGuardado.compareTo(a.fechaGuardado));
  }

  Future<bool> isFavoriteRecipe(String recipeId) async {
    final all = await getAll();
    return all.any(
        (f) => f.tipo == FavoriteType.receta && f.referenciaId == recipeId);
  }

  Future<void> toggleRecipe(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = List<String>.from(prefs.getStringList(_prefsKey) ?? const []);
    final alreadySaved = raw.any((s) {
      final json = jsonDecode(s) as Map<String, dynamic>;
      return json['tipo'] == FavoriteType.receta.name &&
          json['referenciaId'] == recipeId;
    });

    if (alreadySaved) {
      raw.removeWhere((s) {
        final json = jsonDecode(s) as Map<String, dynamic>;
        return json['tipo'] == FavoriteType.receta.name &&
            json['referenciaId'] == recipeId;
      });
    } else {
      final favorite = Favorite(
        id: 'fav_receta_${recipeId}_${DateTime.now().microsecondsSinceEpoch}',
        tipo: FavoriteType.receta,
        referenciaId: recipeId,
        fechaGuardado: DateTime.now(),
      );
      raw.add(jsonEncode(favorite.toJson()));
    }
    await prefs.setStringList(_prefsKey, raw);
  }

  Future<void> addCalculation(String calculationId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = List<String>.from(prefs.getStringList(_prefsKey) ?? const []);
    final favorite = Favorite(
      id: 'fav_calculo_$calculationId',
      tipo: FavoriteType.calculo,
      referenciaId: calculationId,
      fechaGuardado: DateTime.now(),
    );
    raw.add(jsonEncode(favorite.toJson()));
    await prefs.setStringList(_prefsKey, raw);
  }

  Future<void> remove(String favoriteId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = List<String>.from(prefs.getStringList(_prefsKey) ?? const []);
    raw.removeWhere(
        (s) => (jsonDecode(s) as Map<String, dynamic>)['id'] == favoriteId);
    await prefs.setStringList(_prefsKey, raw);
  }

  Future<void> removeCalculationFavorite(String calculationId) async {
    await remove('fav_calculo_$calculationId');
  }
}
