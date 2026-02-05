import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class RegisterIndexPage extends GetView<RegisterIndexController> {
  const RegisterIndexPage({super.key});

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
      8.verticalSpace,

      _buildFormWidget(context),
      _buildAgree(),

      Spacer(),

      _buildBtn(),
    ].toColumn();
  }

  /// 表单输入
  Widget _buildFormWidget(BuildContext context) {
    return GetBuilder<RegisterIndexController>(
      id: "form",
      builder: (controller) {
        return Container(
          color: Colors.white,
          child: Form(
            onChanged: controller.updateButtonState,
            child: <Widget>[
              ListTileWidget(
                padding: EdgeInsets.zero,
                title: TextWidget.label("常用语言").tight(width: 100.w),
                trailing: [
                  IconWidget.svg(
                    text: "中文",
                    fontColor: context.theme.colorScheme.primary,
                    AssetsSvgs.icArrowRightSvg,
                    isReverse: true,
                    width: 16.r,
                    height: 16.r,
                  ),
                ],
                onTap: () => controller.selectLanguage(),
              ).tight(height: 50),

              Divider(height: 1.h, color: Color(0x1A000000)),

              ListTileWidget(
                padding: EdgeInsets.zero,
                leading: <Widget>[
                  ImageWidget.img(
                    "http://${controller.countryModel.nationalFlag}",
                    width: 24.w,
                    height: 18.w,
                    fit: BoxFit.cover,
                    radius: 0,
                  ),
                  IconWidget.svg(
                    AssetsSvgs.icArrowDownSvg,
                    text: "${controller.countryModel.phone}",
                    isReverse: true,
                    onTap: () => controller.toSelectCountryPage(),
                  ),
                ].toRowSpace(space: 4.w).tight(width: 85.w),
                title: TextFormField(
                  controller: controller.phoneController,
                  onTapOutside: (event) =>
                      FocusScope.of(context).requestFocus(FocusNode()),
                  style: TextStyle(
                    fontSize: 14,
                    color: context.theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: "请输入手机号",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ).tight(height: 50),

              Divider(height: 1.h, color: Color(0x1A000000)),

              Visibility(
                visible: !controller.hideVerifyCode,
                child: ListTileWidget(
                  padding: EdgeInsets.zero,
                  leading: TextWidget.label("验证码").tight(width: 85.w),
                  trailing: [
                    TextWidget.label(
                      "获取验证码",
                      color: context.theme.colorScheme.primary,
                    ).onTap(() => controller.gerVerifyCode()),
                  ],
                  title: TextFormField(
                    controller: controller.verifyCodeController,
                    onTapOutside: (event) =>
                        FocusScope.of(context).requestFocus(FocusNode()),
                    style: TextStyle(
                      fontSize: 14,
                      color: context.theme.colorScheme.onSurface,
                      // letterSpacing: 1.2,
                    ),
                    decoration: InputDecoration(
                      hintText: "请输入验证码",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ).tight(height: 50),
              ),

              Divider(height: 1.h, color: Color(0x1A000000)),

              ListTileWidget(
                padding: EdgeInsets.zero,
                leading: TextWidget.label("登录密码").tight(width: 85.w),
                title: TextFormField(
                  controller: controller.passwordController,
                  onTapOutside: (event) =>
                      FocusScope.of(context).requestFocus(FocusNode()),
                  style: TextStyle(
                    fontSize: 14,
                    color: context.theme.colorScheme.onSurface,
                    // letterSpacing: 1.2,
                  ),
                  decoration: InputDecoration(
                    hintText: "请输入密码",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ).tight(height: 50),

              Divider(height: 1.h, color: Color(0x1A000000)),

              ListTileWidget(
                padding: EdgeInsets.zero,
                leading: TextWidget.label("确认密码").tight(width: 85.w),
                title: TextFormField(
                  controller: controller.confirmPasswordController,
                  onTapOutside: (event) =>
                      FocusScope.of(context).requestFocus(FocusNode()),
                  style: TextStyle(
                    fontSize: 14,
                    color: context.theme.colorScheme.onSurface,
                    // letterSpacing: 1.2,
                  ),
                  decoration: InputDecoration(
                    hintText: "请确认密码",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ).tight(height: 50),

              Divider(height: 1.h, color: Color(0x1A000000)),
            ].toColumn().paddingHorizontal(AppSpace.page.w),
          ),
        );
      },
    );
  }

  /// 隐私政策
  Widget _buildAgree() {
    return GetBuilder<RegisterIndexController>(
      id: "privacy",
      builder: (_) {
        return <Widget>[
              Checkbox(
                value: controller.isAgreePrivacy,
                onChanged: controller.updateAgreePrivacy,
                activeColor: Get.theme.colorScheme.primary,
              ),
              TextWidget.muted("我已阅读并同意"),

              TextWidget.muted("《用户协议》", color: Color(0xffFF37A8)).onTap(() {
                Get.toNamed(RouteNames.systemSettingsUserAgreement);
              }),
              TextWidget.muted("《隐私政策》", color: Color(0xffFF37A8)).onTap(() {
                Get.toNamed(RouteNames.systemSettingsPrivacyAgreement);
              }),
            ]
            .toRow(mainAxisAlignment: MainAxisAlignment.start)
            .backgroundColor(Colors.white);
      },
    );
  }

  /// 按钮
  Widget _buildBtn() {
    return GetBuilder<RegisterIndexController>(
      id: "register_btn",
      builder: (controller) {
        return <Widget>[
          ButtonWidget.primary(
            height: 44.h,
            LocaleKeys.commonNext.tr,
            elevation: 0,
            borderRadius: 50,
            enabled: controller.isRegisterEnabled,
            onTap: controller.onNextStep,
          ),
        ].toColumn().paddingHorizontal(AppSpace.page).marginOnly(bottom: 11.h);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterIndexController>(
      init: RegisterIndexController(),
      id: "register_index",
      builder: (_) {
        return Scaffold(
          backgroundColor: Color(0XFFF7F7F7),
          appBar: AppBarWidget(title: "注册账号", backgroundColor: Colors.white),
          body: SafeArea(child: _buildView(context)),
        );
      },
    );
  }
}
