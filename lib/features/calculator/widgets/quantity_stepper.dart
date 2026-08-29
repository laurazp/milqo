import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/dimens.dart';

/// Selector numérico grande con botones +/- y accesos rápidos — apartados
/// 4.3 y 4.4.
class QuantityStepper extends StatelessWidget {
  final double value;
  final String unitLabel;
  final List<QuickQuantity> quickValues;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<double> onQuickValueSelected;

  const QuantityStepper({
    super.key,
    required this.value,
    required this.unitLabel,
    required this.quickValues,
    required this.onIncrement,
    required this.onDecrement,
    required this.onQuickValueSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StepButton(icon: AppConstants.removeIcon, onTap: onDecrement),
            SizedBox(
              width: 140,
              child: Column(
                children: [
                  Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                  ),
                  Text(unitLabel, style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
            _StepButton(icon: AppConstants.addIcon, onTap: onIncrement),
          ],
        ),
        const SizedBox(height: Dimens.mediumMargin),
        Wrap(
          spacing: Dimens.smallMargin,
          alignment: WrapAlignment.center,
          children: quickValues
              .map((q) => ChoiceChip(
                    label: Text(q.label),
                    selected: value == q.value,
                    onSelected: (_) => onQuickValueSelected(q.value),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class QuickQuantity {
  final String label;
  final double value;

  const QuickQuantity(this.label, this.value);
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onTap,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.sageGreen.withValues(alpha: 0.15),
        foregroundColor: AppColors.darkGreen,
      ),
    );
  }
}
