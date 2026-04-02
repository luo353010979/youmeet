import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/pages/home/home_index/index.dart';

class HomeSliderWidget extends GetView<HomeIndexController> {
  const HomeSliderWidget({super.key});

  String _avatarUrl(String portrait) {
    if (portrait.startsWith('http://') || portrait.startsWith('https://')) {
      return portrait;
    }
    return 'http://$portrait';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 164.w,
      child: PageView.builder(
        controller: controller.pageController,
        itemCount: controller.matchList.length,
        itemBuilder: (context, index) {
          final user = controller.matchList[index];
          return _buildUserAvatar(user);
        },
      ),
    );
  }

  Widget _buildUserAvatar(UserMessage user) {
    return <Widget>[
      TextWidget.label(
        LocaleKeys.safeDating.tr,
        weight: FontWeight.w900,
        size: 16,
      ).positioned(left: 16.w, top: 24.w),
      TextWidget.label(
        user.name ?? "",
        size: 18,
        weight: FontWeight.w900,
      ).positioned(left: 245.w, top: 52.w),
      TextWidget.muted(LocaleKeys.commonNext.tr)
          .onTap(() {
            controller.onNextOne();
          })
          .positioned(left: 20.w, top: 107.w),

      /// 头像周围的背景图
      ImageWidget.img(
        AssetsImages.imgHomeAvaterPng,
        width: 264.w,
        height: 148.w,
        fit: BoxFit.contain,
      ).positioned(right: 17.w, bottom: 12.w),

      /// 用户头像，支持左右滑动
      SizedBox(
        width: 127.w,
        height: 127.w,
        child: ImageWidget.img(
          _avatarUrl(user.portrait ?? ""),
          width: 127.w,
          height: 127.w,
          radius: 100,
          fit: BoxFit.cover,
        ),
      ).positioned(left: 95.w, top: 16.w),

      ImageWidget.img(
        AssetsImages.imgHomeYoumeetPng,
        width: 111.w,
        height: 24.w,
        fit: BoxFit.contain,
      ).positioned(top: 76.w, left: 246.w),
      TextWidget.label(
            LocaleKeys.viewNow.tr,
            color: Color(0xFFDA597F),
            weight: FontWeight.w900,
          )
          .onTap(() {
            Get.toNamed(RouteNames.homeMatchingDetail, arguments: user);
          })
          .positioned(left: 247.w, top: 108.5.w),

      TextWidget.label(
        LocaleKeys.reliable.tr,
        size: 26,
        weight: FontWeight.bold,
      ).positioned(left: 16.w, top: 52.w),
      // <Widget>[
      //   TextWidget.label("Genuine", size: 18, weight: FontWeight.bold),
      //   TextWidget.label("&", size: 18, weight: FontWeight.bold),
      //   TextWidget.label("Reliable", size: 18, weight: FontWeight.bold),
      // ].toColumn().positioned(left: 20.w, top: 10.w),
    ].toStack().tight(height: 164.w);
  }
}
