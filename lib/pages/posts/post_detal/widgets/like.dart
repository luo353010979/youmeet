import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:youmeet/common/index.dart';

class LikeWidget extends StatelessWidget {
  const LikeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      ImageWidget.img(AssetsImages.imgMsgAvaterPng, width: 16.r, height: 16.r),

      ImageWidget.img(
        AssetsImages.imgMsgAvaterPng,
        width: 16.r,
        height: 16.r,
      ).positioned(left: 10.w),

      ImageWidget.img(
        AssetsImages.imgMsgAvaterPng,
        width: 16.r,
        height: 16.r,
      ).positioned(left: 20.w),
    ].toStack().tight(width: 44.w, height: 16.r);
  }
}
