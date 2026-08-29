import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/design/app_colors.dart';
import '../core/design/dimens.dart';

/// Aviso de transparencia sobre el origen del ratio — apartado 7: siempre en
/// gris de texto secundario sobre fondo crema/beige, nunca como aviso de
/// error, porque es información de contexto (apartado 2, Principios de UI).
class TransparencyNote extends StatelessWidget {
  final String text;
  final VoidCallback? onInfoTap;

  const TransparencyNote({super.key, this.text = AppConstants.transparencyNote, this.onInfoTap});

  @override
  Widget build(BuildContext context) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(AppConstants.infoIcon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: Dimens.smallMargin),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.3),
          ),
        ),
      ],
    );

    if (onInfoTap == null) return content;

    return InkWell(
      onTap: onInfoTap,
      borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.extraSmallMargin),
        child: content,
      ),
    );
  }
}

/// Hoja informativa corta que abre el icono "i" del banner del Resultado.
void showTransparencyExplanationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.cream,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.cardCornerRadius)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(Dimens.largeMargin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('¿Por qué es orientativo?', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Dimens.mediumMargin),
          Text(
            AppConstants.transparencyExplanation,
            style: const TextStyle(color: AppColors.textPrimary, height: 1.4),
          ),
          const SizedBox(height: Dimens.largeMargin),
        ],
      ),
    ),
  );
}
