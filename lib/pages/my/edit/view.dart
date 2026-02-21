import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/i18n/index.dart';
import 'package:youmeet/common/widgets/index.dart';

import 'index.dart';

class EditPage extends GetView<EditController> {
  const EditPage({super.key});

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: <Widget>[
        8.verticalSpace,

        InputWidget(
          controller: controller.nicknameController,
          autofocus: true,
          cleanable: true,
          placeholder: LocaleKeys.commonEditPlaceholder.tr,
          borderRadius: BorderRadius.zero,
        ).tight(height: 50.h),
      ].toColumn(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditController>(
      init: EditController(),
      id: "edit",
      builder: (_) {
        return Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          appBar: AppBarWidget(
            title: LocaleKeys.commonEdit.tr,
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Center(
                  child: ButtonWidget.primary(
                    LocaleKeys.commonBottomConfirm.tr,
                    width: 60.w,
                    height: 25.h,
                    onTap: controller.onConfirm,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
