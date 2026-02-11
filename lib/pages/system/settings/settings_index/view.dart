import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class SettingsIndexPage extends GetView<SettingsIndexController> {
  const SettingsIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 8.h),
      child:
          <Widget>[
                ListTileWidget(
                  padding: EdgeInsets.zero,
                  title: TextWidget.label("消息通知", weight: FontWeight.w500),
                  trailing: [
                    CupertinoSwitch(
                      value: controller.value1,
                      onChanged: controller.onChanged1,
                      activeTrackColor: Get.theme.colorScheme.primary,
                    ).scale(all: 0.8),
                  ],
                ).tight(height: 44.h),

                ListTileWidget(
                  padding: EdgeInsets.zero,
                  title: TextWidget.label("定位", weight: FontWeight.w500),
                  trailing: [
                    CupertinoSwitch(
                      value: controller.value2,
                      onChanged: controller.onChanged2,
                      activeTrackColor: Get.theme.colorScheme.primary,
                    ).scale(all: 0.8),
                  ],
                ).tight(height: 44.h),

                ListTileWidget(
                  padding: EdgeInsets.zero,
                  title: TextWidget.label("个性化推荐", weight: FontWeight.w500),
                  trailing: [
                    CupertinoSwitch(
                      value: controller.value3,
                      onChanged: controller.onChanged3,
                      activeTrackColor: Get.theme.colorScheme.primary,
                    ).scale(all: 0.8),
                  ],
                ).tight(height: 44.h),

                ListTileWidget(
                  padding: EdgeInsets.zero,
                  title: TextWidget.label("青少年模式", weight: FontWeight.w500),
                  trailing: [
                    CupertinoSwitch(
                      value: controller.value4,
                      onChanged: controller.onChanged4,
                      activeTrackColor: Get.theme.colorScheme.primary,
                    ).scale(all: 0.8),
                  ],
                ).tight(height: 44.h),

                ListTileWidget(
                  padding: EdgeInsets.zero,
                  title: TextWidget.label("用户协议", weight: FontWeight.w500),
                  trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
                  onTap: () =>
                      Get.toNamed(RouteNames.systemSettingsUserAgreement),
                ).tight(height: 44.h),

                ListTileWidget(
                  padding: EdgeInsets.zero,
                  title: TextWidget.label("隐私协议", weight: FontWeight.w500),
                  trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
                  onTap: () =>
                      Get.toNamed(RouteNames.systemSettingsPrivacyAgreement),
                ).tight(height: 44.h),

                ListTileWidget(
                  padding: EdgeInsets.zero,
                  title: TextWidget.label("关于我们", weight: FontWeight.w500),
                  trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
                  onTap: () => Get.toNamed(RouteNames.systemSettingsAboutUs),
                ).tight(height: 44.h),

                ListTileWidget(
                  padding: EdgeInsets.zero,
                  title: TextWidget.label("退出登录", weight: FontWeight.w500),
                  trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
                  onTap: UserService.to.logout,
                ).tight(height: 44.h),
              ]
              .toColumn(mainAxisSize: MainAxisSize.min)
              .paddingHorizontal(AppSpace.page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsIndexController>(
      init: SettingsIndexController(),
      id: "settings_index",
      builder: (_) {
        return Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          appBar: AppBarWidget(title: "设置", backgroundColor: Colors.white),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
