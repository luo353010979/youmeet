import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';

class ColumTextWidget extends StatelessWidget {
  const ColumTextWidget({
    super.key,
    required this.keyText,
    required this.valueText,
    this.spacing,
  });

  final double? spacing;
  final Widget keyText;
  final Widget valueText;

  @override
  Widget build(BuildContext context) {
    return <Widget>[keyText, valueText].toColumnSpace(
      space: spacing ?? 0,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
