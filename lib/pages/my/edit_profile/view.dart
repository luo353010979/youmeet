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
      child: <Widget>[
        32.verticalSpace,
        _buildAvatar(),

        40.verticalSpace,

        TextWidget.muted("展示墙"),

        8.verticalSpace,

        ImageSelectorWidget(
          images: UserService.to.profile.pic?.split(","),
          maxImages: 3,
          onImagesSelected: (imagePaths) {
            controller.setImagePaths(imagePaths);
          },
        ),

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
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(AppSpace.page.w),
    );
  }

  /// 头像
  Widget _buildAvatar() {
    return <Widget>[
      ImageWidget.img(
        "http://${UserService.to.profile.portrait}",
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

  /// 视频展示墙
  Widget _buildVideo() {
    return IconWidget.svg(AssetsSvgs.icProfileAddVideoSvg, width: 80.w, height: 80.w)
        .center()
        .tight(width: 343.w, height: 180.h)
        .decorated(
          border: Border.all(color: Color(0xFFF1F1F1), width: 1.w),
        )
        .onTap(() {
          // controller.pickMultipleImages();
          //todo 视频展示墙
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
                    onTap: () {
                      controller.saveProfile();
                    },
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
