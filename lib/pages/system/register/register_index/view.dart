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
                title: TextWidget.label(
                  LocaleKeys.commonLanguage.tr,
                ).tight(width: 100.w),
                trailing: [
                  IconWidget.svg(
                    text: controller.currentLanguage,
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
                    hintText: LocaleKeys.phonePlaceholder.tr,
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
                  leading: TextWidget.label(
                    LocaleKeys.verifyCode.tr,
                  ).tight(width: 85.w),
                  trailing: [
                    TextWidget.label(
                      LocaleKeys.getVerifyCode.tr,
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
                      hintText: LocaleKeys.verifyPlaceHolder.tr,
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ).tight(height: 50),
              ),

              Divider(height: 1.h, color: Color(0x1A000000)),

              ListTileWidget(
                padding: EdgeInsets.zero,
                leading: TextWidget.label(
                  LocaleKeys.loginPassword.tr,
                ).tight(width: 85.w),
                title: TextFormField(
                  obscureText: true,
                  controller: controller.passwordController,
                  onTapOutside: (event) =>
                      FocusScope.of(context).requestFocus(FocusNode()),
                  style: TextStyle(
                    fontSize: 14,
                    color: context.theme.colorScheme.onSurface,
                    // letterSpacing: 1.2,
                  ),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.loginPassword.tr,
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ).tight(height: 50),

              Divider(height: 1.h, color: Color(0x1A000000)),

              ListTileWidget(
                padding: EdgeInsets.zero,
                leading: TextWidget.label(
                  LocaleKeys.confirmPassword.tr,
                ).tight(width: 85.w),
                title: TextFormField(
                  obscureText: true,
                  controller: controller.confirmPasswordController,
                  onTapOutside: (event) =>
                      FocusScope.of(context).requestFocus(FocusNode()),
                  style: TextStyle(
                    fontSize: 14,
                    color: context.theme.colorScheme.onSurface,
                    // letterSpacing: 1.2,
                  ),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.confirmPassword.tr,
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
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(bottom: 10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: controller.isAgreePrivacy,
                onChanged: controller.updateAgreePrivacy,
                activeColor: Get.theme.colorScheme.primary,
              ),
              Expanded(
                child: Wrap(
                  spacing: 2.w,
                  runSpacing: 2.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextWidget.muted(LocaleKeys.agreeTerms.tr),
                    TextWidget.muted(
                      "《${LocaleKeys.userAgreement.tr}》",
                      color: const Color(0xffFF37A8),
                    ).onTap(() {
                      Get.toNamed(RouteNames.systemSettingsUserAgreement);
                    }),
                    TextWidget.muted(
                      "《${LocaleKeys.privacyPolicy.tr}》",
                      color: const Color(0xffFF37A8),
                    ).onTap(() {
                      Get.toNamed(RouteNames.systemSettingsPrivacyAgreement);
                    }),
                  ],
                ).paddingOnly(top: 13.h, right: AppSpace.page.w),
              ),
            ],
          ),
        );
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
          appBar: AppBarWidget(
            title: LocaleKeys.loginSignUp.tr,
            backgroundColor: Colors.white,
          ),
          body: SafeArea(child: _buildView(context)),
        );
      },
    );
  }
}
