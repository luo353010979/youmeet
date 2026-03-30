import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  Widget _buildAppLogo() {
    return ImageWidget.img(
      "assets/icons/ic_logo.png",
      width: 100.w,
      height: 100.h,
      fit: BoxFit.contain,
    ).paddingOnly(top: 156.h);
  }

  /// 表单输入
  Widget _buildFormWidget(BuildContext context) {
    return GetBuilder<LoginController>(
      id: "form",
      builder: (_) {
        return Form(
          onChanged: controller.updateButtonState,
          child:
              <Widget>[
                    TextFormField(
                      controller: controller.usernameController,
                      focusNode: controller.usernameFocusNode,
                      textInputAction: TextInputAction.next,

                      onFieldSubmitted: (value) {
                        controller.passwordFocusNode.requestFocus();
                      },
                      style: TextStyle(
                        fontSize: 14,
                        color: context.theme.colorScheme.onSurface,
                      ),
                      onTapOutside: (event) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon:
                            controller.usernameController.text.isNotEmpty
                            ? IconButton(
                                onPressed: controller.clearUsername,
                                icon: Icon(Icons.clear, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              )
                            : null,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                            width: 1,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.white),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                        hintText: LocaleKeys.usernamePlaceholder.tr,
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),

                    TextFormField(
                      controller: controller.passwordController,
                      focusNode: controller.passwordFocusNode,
                      // textInputAction: TextInputAction.done,
                      // onFieldSubmitted: (value) {
                      //   if (controller.isLoginEnabled) {
                      //     controller.onLogin();
                      //   }
                      // },
                      style: TextStyle(
                        fontSize: 14,
                        color: context.theme.colorScheme.onSurface,
                      ),
                      onTapOutside: (event) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      obscureText: controller.isPasswordHidden,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: <Widget>[
                          if (controller.passwordController.text.isNotEmpty)
                            IconButton(
                              onPressed: controller.clearPassword,
                              icon: Icon(Icons.clear, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          IconButton(
                            onPressed: controller.hidePwd,
                            icon: Icon(
                              controller.isPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ).paddingHorizontal(8),
                        ].toRow(mainAxisSize: MainAxisSize.min),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                            width: 1,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.white),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                        hintText: LocaleKeys.passwordPlaceholder.tr,
                        hintStyle: TextStyle(fontSize: 14),
                      ),
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
      TextWidget.muted(LocaleKeys.agreeTerms.tr),

      TextWidget.muted(
        "《${LocaleKeys.userAgreement.tr}》",
        color: Color(0xffFF37A8),
      ).onTap(() {
        Get.toNamed(RouteNames.systemSettingsUserAgreement);
      }),
      TextWidget.muted(
        "《${LocaleKeys.privacyPolicy.tr}》",
        color: Color(0xffFF37A8),
      ).onTap(() {
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
                // enabled: controller.isLoginEnabled,
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
  Widget _buildView(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(Get.context!).size.height -
              MediaQuery.of(Get.context!).padding.top -
              MediaQuery.of(Get.context!).padding.bottom,
        ),
        child: IntrinsicHeight(
          child: <Widget>[
            _buildAppLogo(),
            Spacer(),
            _buildFormWidget(context),
            _buildAgree(),
            _buildBtn(),
          ].toColumn(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      id: "login",
      builder: (_) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetsImages.imgBackgroundLoginPng),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(child: _buildView(context)),
          ),
        );
      },
    );
  }
}
