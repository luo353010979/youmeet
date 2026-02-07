import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/pages/index.dart';

class EditProfilePage extends GetView<MyIndexController> {
  const EditProfilePage({super.key});

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child:
          <Widget>[
                32.verticalSpace,
                _buildAvatar(),

                40.verticalSpace,

                TextWidget.muted("展示墙"),

                8.verticalSpace,

                _buildImages(),

                12.verticalSpace,

                _buildVideo(),

                16.verticalSpace,

                ListTileWidget(
                  padding: EdgeInsets.zero,
                  title: TextWidget.body("个人资料", weight: FontWeight.w500),
                  trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
                  onTap: () {
                    Get.toNamed(RouteNames.myEditProfileInfo);
                  },
                ).tight(height: 56.h),
                Divider(height: 1.h, color: Color(0x1A333333)),

                ListTileWidget(
                  padding: EdgeInsets.zero,
                  title: TextWidget.body("交友资料", weight: FontWeight.w500),
                  trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
                  onTap: () {},
                ).tight(height: 56.h),

                Divider(height: 1.h, color: Color(0x1A333333)),
              ]
              .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
              .paddingHorizontal(AppSpace.page.w),
    );
  }

  /// 头像
  Widget _buildAvatar() {
    return <Widget>[
      ImageWidget.img(
        "http://${controller.userMessage.portrait}",
        width: 80.w,
        height: 80.w,
        radius: 50,
        fit: BoxFit.cover,
      ),

      Positioned(
        bottom: 0,
        right: 0,
        child: IconWidget.svg(
          AssetsSvgs.icProfileAddSvg,
          // width: 24.w,
          // height: 24.w,
          onTap: controller.pickImage,
        ),
      ),
    ].toStack().center();
  }

  /// 图片展示墙
  Widget _buildImages() {
    const maxImages = 3;
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
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: ImageWidget.img(
              controller.selectedImages[index],
              width: 108.w,
              height: 108.w,
              fit: BoxFit.cover,
            ).clipRRect(all: 12.r),
          );
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

  /// 视频展示墙
  Widget _buildVideo() {
    return IconWidget.svg(
          AssetsSvgs.icProfileAddVideoSvg,
          width: 80.w,
          height: 80.w,
        )
        .center()
        .tight(width: 343.w, height: 180.h)
        .decorated(
          border: Border.all(color: Color(0xFFF1F1F1), width: 1.w),
        )
        .onTap(() {
          controller.pickMultipleImages();
        });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyIndexController>(
      id: "edit_profile",
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarWidget(
            title: "编辑个人信息",
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Center(
                  child: ButtonWidget.primary(
                    "保存",
                    width: 50.w,
                    height: 25.h,
                    onTap: () {},
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
