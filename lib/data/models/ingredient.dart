import 'package:flutter/material.dart';

/// Ingrediente del catálogo — apartado 5 de la especificación.
class Ingredient {
  final String id;
  final String nombre;

  /// Artículo determinado ("el"/"la"), para componer frases genéricas como
  /// los pasos de preparación de la pantalla Resultado.
  final String articulo;
  final Color color;
  final IconData icon;
  final String remojoRecomendado;
  final bool requiereColado;
  final int rangoMinG;
  final int rangoMaxG;

  /// Tiempo de batido a máxima potencia — apartado 6, usado en los pasos de
  /// preparación genéricos de la pantalla Resultado.
  final String tiempoBatido;

  const Ingredient({
    required this.id,
    required this.nombre,
    required this.articulo,
    required this.color,
    required this.icon,
    required this.remojoRecomendado,
    required this.requiereColado,
    required this.rangoMinG,
    required this.rangoMaxG,
    required this.tiempoBatido,
  });

  /// [icon] no viaja en el JSON — un `IconData` no es contenido, es una
  /// decisión de diseño que vive en código (ver `ingredient_icons.dart`).
  factory Ingredient.fromJson(Map<String, dynamic> json, {required IconData icon}) {
    final hex = json['colorHex'] as String;
    return Ingredient(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      articulo: json['articulo'] as String,
      color: Color(int.parse('FF$hex', radix: 16)),
      icon: icon,
      remojoRecomendado: json['remojoRecomendado'] as String,
      requiereColado: json['requiereColado'] as bool,
      rangoMinG: json['rangoMinG'] as int,
      rangoMaxG: json['rangoMaxG'] as int,
      tiempoBatido: json['tiempoBatido'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'articulo': articulo,
        'colorHex': color.toARGB32().toRadixString(16).substring(2).toUpperCase(),
        'remojoRecomendado': remojoRecomendado,
        'requiereColado': requiereColado,
        'rangoMinG': rangoMinG,
        'rangoMaxG': rangoMaxG,
        'tiempoBatido': tiempoBatido,
      };
}
