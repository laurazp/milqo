import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/saved_calculation.dart';

/// Cálculos guardados en Favoritos &gt; Cálculos guardados (apartado 4.10).
/// Almacenamiento local en la v1, sin cuenta de usuario ni backend.
class CalculationsRepository {
  static const _prefsKey = 'milqo_saved_calculations';

  Future<List<SavedCalculation>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = List<String>.from(prefs.getStringList(_prefsKey) ?? const []);
    return raw
        .map((s) => SavedCalculation.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
  }

  Future<void> save(SavedCalculation calculation) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = List<String>.from(prefs.getStringList(_prefsKey) ?? const []);
    raw.add(jsonEncode(calculation.toJson()));
    await prefs.setStringList(_prefsKey, raw);
  }

  Future<void> remove(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = List<String>.from(prefs.getStringList(_prefsKey) ?? const []);
    raw.removeWhere((s) =>
        (jsonDecode(s) as Map<String, dynamic>)['id'] == id);
    await prefs.setStringList(_prefsKey, raw);
  }
}
