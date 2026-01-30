import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:youmeet/common/index.dart';

class ColumTextWidget extends StatelessWidget {
  const ColumTextWidget({
    super.key,
    required this.keyText,
    required this.valueText,
  });

  final String keyText;
  final String valueText;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      TextWidget.h4(valueText, weight: FontWeight.bold),
      TextWidget.muted(keyText),
    ].toColumn();
  }
}
