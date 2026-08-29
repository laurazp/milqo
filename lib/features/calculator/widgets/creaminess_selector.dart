import 'package:flutter/material.dart';

import '../../../core/design/dimens.dart';
import '../../../data/models/creaminess.dart';

/// Selector de cremosidad: Ligera / Normal / Cremosa — apartado 4.3.
class CreaminessSelector extends StatelessWidget {
  final Creaminess value;
  final ValueChanged<Creaminess> onChanged;

  const CreaminessSelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Creaminess.values
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Center(child: Text(c.label)),
                    selected: value == c,
                    onSelected: (_) => onChanged(c),
                    padding: const EdgeInsets.symmetric(vertical: Dimens.smallMargin),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
