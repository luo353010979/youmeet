import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class SendPostPage extends GetView<SendPostController> {
  const SendPostPage({super.key});

  // 主视图
  Widget _buildView(BuildContext context) {
    return SingleChildScrollView(
      child:
          <Widget>[
                TextField(
                  controller: controller.contentController,
                  focusNode: controller.contentFocusNode,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.theme.colorScheme.onSurface,
                  ),
                  onTapOutside: (event) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: "这一刻想法",
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                ),
                20.verticalSpace,

                ImageSelectorWidget(
                  maxImages: 9,
                  onImagesSelected: controller.setImagePaths,
                ),
              ]
              .toColumn(mainAxisSize: MainAxisSize.min)
              .padding(horizontal: 16.w, bottom: 16.w)
              .backgroundColor(Colors.white)
              .marginOnly(top: 8.h),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SendPostController>(
      init: SendPostController(),
      id: "send_feed",
      builder: (_) {
        return Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          appBar: AppBarWidget(
            title: "发布动态",
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: ImageWidget.img(
                  AssetsImages.imgPostsSendPng,
                  width: 76.w,
                  height: 26.w,
                ).onTap(controller.sendFeed),
              ),
            ],
          ),
          body: SafeArea(child: _buildView(context)),
        );
      },
    );
  }
}
