import 'package:ducafe_ui_core/ducafe_ui_core.dart' hide SizedBoxExtensions;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class RegisterIndexPage extends GetView<RegisterIndexController> {
  const RegisterIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[

      8.verticalSpace,

      _buildFormWidget(),
      _buildAgree(),

      Spacer(),

      _buildBtn(),
    ].toColumn();
  }

  /// 表单输入
  Widget _buildFormWidget() {
    return GetBuilder<RegisterIndexController>(
      id: "form",
      builder: (controller) {
        return Container(
          color: Colors.white,
          child: Form(
            onChanged: controller.updateButtonState,
            child:
                <Widget>[
                      InputFormFieldWidget(
                        readOnly: true,
                        prefix: TextWidget.label("常用语言").tight(width: 100.w),
                        suffix: IconWidget.img(
                          text: "中文",
                          fontColor: Get.theme.colorScheme.primary,
                          AssetsImages.icArrowRightPng,
                          isReverse: true,
                          width: 16.r,
                          height: 16,
                          onTap: () => controller.selectLanguage,
                        ),
                        border: Border(
                          bottom: BorderSide(color: Color(0xffE6E6E6)),
                        ),
                        borderRadius: BorderRadius.zero,
                      ).tight(height: 50).paddingTop(20),

                      InputFormFieldWidget(
                        prefix: TextWidget.label("手机号").tight(width: 100.w),
                        controller: controller.phoneController,
                        placeholder: "请输入手机号",
                        keyboardType: TextInputType.phone,
                        border: Border(
                          bottom: BorderSide(color: Color(0xffE6E6E6)),
                        ),
                        borderRadius: BorderRadius.zero,
                      ).tight(height: 50),

                      InputFormFieldWidget(
                        prefix: TextWidget.label("验证码").tight(width: 100.w),
                        suffix: TextWidget.label(
                          "获取验证码",
                        ).onTap(() => controller.gerVerifyCode()),
                        controller: controller.codeController,
                        placeholder: "请输入验证码",
                        keyboardType: TextInputType.phone,
                        border: Border(
                          bottom: BorderSide(color: Color(0xffE6E6E6)),
                        ),
                        borderRadius: BorderRadius.zero,
                      ).tight(height: 50),

                      InputFormFieldWidget(
                        prefix: TextWidget.label("设置登录密码").tight(width: 100.w),
                        controller: controller.passwordController,
                        placeholder: "请输入手机号",
                        keyboardType: TextInputType.phone,
                        border: Border(
                          bottom: BorderSide(color: Color(0xffE6E6E6)),
                        ),
                        borderRadius: BorderRadius.zero,
                      ).tight(height: 50),

                      InputFormFieldWidget(
                        prefix: TextWidget.label("再次确认密码").tight(width: 100.w),
                        controller: controller.confirmPasswordController,
                        placeholder: "请再次确认密码",
                        keyboardType: TextInputType.phone,
                        border: Border(
                          bottom: BorderSide(color: Color(0xffE6E6E6)),
                        ),
                        borderRadius: BorderRadius.zero,
                      ).tight(height: 50),
                    ]
                    .toColumnSpace(
                      space: AppSpace.page,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    )
                    .paddingLeft(AppSpace.page),
          ),
        );
      },
    );
  }

  /// 隐私政策
  Widget _buildAgree() {
    return Container(
      color: Colors.white,
      child: <Widget>[
        Checkbox(value: true, onChanged: (value) {}),
        TextWidget.muted("我已阅读并同意"),

        TextWidget.muted("《用户协议》", color: Color(0xffFF37A8)).onTap(() {
          Get.toNamed(RouteNames.systemSettingsUserAgreement);
        }),
        TextWidget.muted("《隐私政策》", color: Color(0xffFF37A8)).onTap(() {
          Get.toNamed(RouteNames.systemSettingsPrivacyAgreement);
        }),
      ].toRow(mainAxisAlignment: MainAxisAlignment.start).paddingLeft(10.w),
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
          appBar: AppBarWidget(title: "注册账号"),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
