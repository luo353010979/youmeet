import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/pages/index.dart';

class EditProfileInfoPage extends GetView<MyIndexController> {
  const EditProfileInfoPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      ListTileWidget(
        padding: EdgeInsets.only(left: 16),
        leading: TextWidget.label("昵称").tight(width: 80.w),
        title: TextWidget.label(
          controller.userMessage.name ?? "",
          color: Color(0xFF666666),
        ),
        trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
        onTap: () {},
      ).tight(height: 50.h),

      Divider(height: 1.h, color: Color(0x1A333333)),

      ListTileWidget(
        padding: EdgeInsets.only(left: 16),
        leading: TextWidget.label("简介").tight(width: 80.w),
        title: TextWidget.label(
          controller.userMessage.profile ?? "未填写",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: Color(0xFF666666),
        ),
        trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
        onTap: () {},
      ).tight(height: 50.h),

      8.verticalSpace,

      ListTileWidget(
        padding: EdgeInsets.only(left: 16),
        leading: TextWidget.label("性别").tight(width: 80.w),
        title: TextWidget.label(
          controller.userMessage.sex == 1 ? "男" : "女",
          color: Color(0xFF666666),
        ),
        trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
        onTap: () {},
      ).tight(height: 50.h),
      Divider(height: 1.h, color: Color(0x1A333333)),

      ListTileWidget(
        padding: EdgeInsets.only(left: 16),
        leading: TextWidget.label("生日").tight(width: 80.w),
        title: TextWidget.label(
          "${controller.userMessage.birthday}",
          color: Color(0xFF666666),
        ),
        trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
        onTap: () {},
      ).tight(height: 50.h),

      Divider(height: 1.h, color: Color(0x1A333333)),

      ListTileWidget(
        padding: EdgeInsets.only(left: 16),
        leading: TextWidget.label("身高").tight(width: 80.w),
        title: TextWidget.label(
          "${controller.userMessage.height ?? "0"} cm",
          color: Color(0xFF666666),
        ),
        trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
        onTap: () {},
      ).tight(height: 50.h),

      Divider(height: 1.h, color: Color(0x1A333333)),

      ListTileWidget(
        padding: EdgeInsets.only(left: 16),
        leading: TextWidget.label("体重").tight(width: 80.w),
        title: TextWidget.label(
          "${controller.userMessage.weight ?? "0"} kg",
          color: Color(0xFF666666),
        ),
        trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
        onTap: () {},
      ).tight(height: 50.h),

      Divider(height: 1.h, color: Color(0x1A333333)),

      ListTileWidget(
        padding: EdgeInsets.only(left: 16),
        leading: TextWidget.label("个性标签").tight(width: 80.w),
        title: TextWidget.label("二次元、夜猫子、社交达人、开心的吃货", color: Color(0xFF666666)),
        trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
        onTap: () {},
      ).tight(height: 50.h),

      8.verticalSpace,

      ListTileWidget(
        padding: EdgeInsets.only(left: 16),
        leading: TextWidget.label("身份验证").tight(width: 80.w),
        title: TextWidget.label("已验证", color: Color(0xFF666666)),
        trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
      ).tight(height: 50.h),

      Divider(height: 1.h, color: Color(0x1A333333)),

      ListTileWidget(
        padding: EdgeInsets.only(left: 16),
        leading: TextWidget.label("我的语言").tight(width: 80.w),
        title: TextWidget.label("中文", color: Color(0xFF666666)),
        trailing: [IconWidget.svg(AssetsSvgs.icArrowRight2Svg)],
        onTap: () {},
      ).tight(height: 50.h),
    ].toColumn().marginOnly(top: 12.h);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyIndexController>(
      id: "edit_profile_info",
      builder: (_) {
        return Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          appBar: AppBarWidget(
            title: "个人资料",
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
