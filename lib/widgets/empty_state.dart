import 'package:flutter/material.dart';

import '../core/design/app_colors.dart';
import '../core/design/dimens.dart';

/// Estado vacío sencillo — usado en Favoritos cuando no hay nada guardado
/// (apartado 4.10).
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.hugeMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: Dimens.mediumMargin),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
