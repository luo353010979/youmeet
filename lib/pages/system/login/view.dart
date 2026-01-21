import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  Widget _buildAppLogo() {
    return ImageWidget.img(
      "assets/launcher/ios.png",
      width: 100.w,
      height: 100.h,
      fit: BoxFit.contain,
    ).paddingOnly(top: 156.h);
  }

  /// 表单输入
  Widget _buildFormWidget() {
    return GetBuilder<LoginController>(
      id: "form",
      builder: (controller) {
        return Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: controller.updateButtonState,
          child:
              <Widget>[
                    // 账号
                    InputFormFieldWidget(
                      controller: controller.usernameController,
                      placeholder: LocaleKeys.usernamePlaceholder.tr,
                    ),

                    // 密码
                    InputFormFieldWidget(
                      controller: controller.passwordController,
                      placeholder: LocaleKeys.passwordPlaceholder.tr,
                      obscureText: true,
                    ),
                  ]
                  .toColumnSpace(
                    space: AppSpace.page,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )
                  .paddingHorizontal(AppSpace.page),
        );
      },
    );
  }

  /// 隐私政策
  Widget _buildAgree() {
    return <Widget>[
      Checkbox(value: true, onChanged: (value) {}),
      TextWidget.muted("我已阅读并同意"),

      TextWidget.muted("《用户协议》", color: Color(0xffFF37A8)).onTap(() {
        Get.toNamed(RouteNames.systemSettingsUserAgreement);
      }),
      TextWidget.muted("《隐私政策》", color: Color(0xffFF37A8)).onTap(() {
        Get.toNamed(RouteNames.systemSettingsPrivacyAgreement);
      }),
    ].toRow(mainAxisAlignment: MainAxisAlignment.start);
  }

  /// 按钮
  Widget _buildBtn() {
    return GetBuilder<LoginController>(
      id: "login_btn",
      builder: (controller) {
        return <Widget>[
              ButtonWidget.primary(
                height: 44.h,
                LocaleKeys.loginSignIn.tr,
                elevation: 0,
                borderRadius: 50,
                enabled: controller.isLoginEnabled,
                onTap: controller.onLogin,
              ),

              ButtonWidget.ghost(
                height: 44.h,
                LocaleKeys.loginSignUp.tr,
                onTap: controller.onRegister,
              ),
            ]
            .toColumn()
            .paddingHorizontal(AppSpace.page.w)
            .marginOnly(bottom: 11.h);
      },
    );
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildAppLogo(),
      Spacer(),
      _buildFormWidget(),
      _buildAgree(),
      _buildBtn(),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      id: "login",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("login")),
          backgroundColor: const Color.fromARGB(255, 247, 183, 204),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
