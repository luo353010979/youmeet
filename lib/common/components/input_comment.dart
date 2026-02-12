import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class InputCommentWidget extends StatelessWidget {
  const InputCommentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      InputWidget(
        placeholder: "发表评论",
        borderRadius: BorderRadius.circular(8.r),
        autofocus: true,
        cleanable: false,
        onSubmitted: (value) {
          Get.back(result: value);
        },
      ).expanded(),

      IconButton(
        onPressed: () {},
        icon: IconWidget.svg(AssetsSvgs.icMsgCameraSvg, size: 24.r),
      ),

      IconButton(
        onPressed: () {},
        icon: IconWidget.svg(AssetsSvgs.icMsgAddSvg, size: 24.r),
      ),
    ].toRow().tight(height: 60.h).backgroundColor(Colors.white);
  }
}
