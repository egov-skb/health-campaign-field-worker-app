import 'package:digit_ui_components/theme/spacers.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorContainer extends StatelessWidget {
  final String label;
  final String prefixLabel;
  final String suffixLabel;
  final double value;
  final String? subLabel;
  final Animation<Color?>? valueColor;

  const ProgressIndicatorContainer({
    super.key,
    required this.label,
    required this.prefixLabel,
    required this.suffixLabel,
    required this.value,
    this.valueColor,
    this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          label,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(spacer2 * 2),
          child: Column(
            children: [
              LinearProgressIndicator(
                valueColor: valueColor ??
                    AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.onSurfaceVariant,
                    ),
                value: value,
                minHeight: 7.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: spacer2 + 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      prefixLabel,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      suffixLabel,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (subLabel != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(spacer2),
              child: Text(
                subLabel ?? '',
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
