import 'package:flutter/material.dart';

/// Paleta de color del MVP — apartado 2 de la especificación. Se mantiene
/// sin cambios respecto a la v0.1: suave pero alegre, con un color de acento
/// por ingrediente para reconocerlo de un vistazo en toda la app.
abstract class AppColors {
  /// Fondo general de todas las pantallas.
  static const cream = Color(0xFFFBF7EF);

  /// Botones principales, CTA, estados activos.
  static const sageGreen = Color(0xFF6EA876);

  /// Textos destacados sobre fondo claro, iconografía.
  static const darkGreen = Color(0xFF4A7A54);

  /// Ingrediente avena, chips de cantidad.
  static const oatOrange = Color(0xFFF0A55A);

  /// Ingredientes pistacho/anacardo, utilidad Conversor.
  static const pistachioLilac = Color(0xFFB09ED6);

  /// Icono de corazón, botón "Guardar en favoritos".
  static const favoriteCoral = Color(0xFFEE827A);

  /// Texto de cuerpo y títulos.
  static const textPrimary = Color(0xFF3A362F);

  static const textSecondary = Color(0xFF8B8577);
  static const cardSurface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE9E2D3);

  /// Colores de acento adicionales, no fijados explícitamente en el
  /// documento de diseño (que solo define avena y pistacho/anacardo): se
  /// eligen dentro de la misma paleta cálida y natural para que almendra y
  /// arroz también sean reconocibles de un vistazo.
  static const almondTan = Color(0xFFC9A66B);
  static const riceBeige = Color(0xFFAFC08A);
}
