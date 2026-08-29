const _spanishMonths = [
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic',
];

/// Formatea una fecha como "6 mar 2026", sin depender de `package:intl` ni
/// de inicializar datos de localización — usado en las tarjetas de
/// Favoritos (apartado 4.10).
String formatShortDate(DateTime date) =>
    '${date.day} ${_spanishMonths[date.month - 1]} ${date.year}';
