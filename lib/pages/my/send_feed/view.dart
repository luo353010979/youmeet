import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class SendFeedPage extends GetView<SendFeedController> {
  const SendFeedPage({super.key});

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
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
      _buildImages(),
    ].toColumn().paddingHorizontal(16.w);
  }

  Widget _buildImages() {
    const maxImages = 9;
    final imageCount = controller.selectedImages.length;
    final showPlaceholder = imageCount < maxImages;
    final totalItems = showPlaceholder ? imageCount + 1 : imageCount;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.w,
        crossAxisSpacing: 8.w,
        // childAspectRatio: 1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        if (index < imageCount) {
          // 显示已选择的图片
          return ImageWidget.file(
            controller.selectedImages[index],
            width: 108.w,
            height: 108.w,
            fit: BoxFit.cover,
          ).clipRRect(all: 12.r);
        } else {
          // 显示上传占位符（只在未满时显示一个）
          return IconWidget.svg(
                AssetsSvgs.icProfileAdd2Svg,
                width: 16.w,
                height: 16.w,
              )
              .center()
              .decorated(
                border: Border.all(color: Color(0xFFF1F1F1), width: 1.w),
              )
              .onTap(() {
                controller.pickMultipleImages(
                  maxImages: maxImages - imageCount,
                );
              });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SendFeedController>(
      init: SendFeedController(),
      id: "send_feed",
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarWidget(
            leading: ButtonWidget.text(
              "取消",
              onTap: () {
                Get.back();
              },
            ),
            title: "发布动态",
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: ButtonWidget.primary(
                  width: 50.w,
                  height: 32.h,
                  "发布",
                  fontSize: 12,
                  onTap: controller.sendFeed,
                ),
              ),
            ],
          ),
          body: SafeArea(child: _buildView(context)),
        );
      },
    );
  }
}
