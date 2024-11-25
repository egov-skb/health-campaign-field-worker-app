import 'package:digit_ui_components/widgets/atoms/label_value_list.dart';
import 'package:flutter/material.dart';

class DigitTableCard extends StatelessWidget {
  final Map<String, dynamic> element;
  final Border? border;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double gap;
  final num fraction;
  final EdgeInsetsGeometry? topPadding;
  final TextStyle? labelStyle;
  final TextStyle? descriptionStyle;

  const DigitTableCard({
    super.key,
    required this.element,
    this.border,
    this.color,
    this.padding,
    this.gap = 0,
    this.fraction = 1.8,
    this.topPadding,
    this.labelStyle,
    this.descriptionStyle,
  });

  @override
  Widget build(BuildContext context) {
    return LabelValueList(
        labelFlex: 6,
        maxLines: 2,
        items: element.keys
            .map((e)=>LabelValuePair(
            label: e,
            value: element[e].toString(),

        )
        ).toList(),
    );
  }
}
