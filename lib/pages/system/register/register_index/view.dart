import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

import 'index.dart';

class RegisterIndexPage extends GetView<RegisterIndexController> {
  const RegisterIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      ListTileWidget(
        title: TextWidget.label("常用语言"),
        trailing: [
          IconWidget.img(
            text: "中文",
            AssetsImages.icArrowRightPng,
            isReverse: true,
            width: 16.r,
            height: 16,
          ),
        ],
      ),

      InputWidget(
        prefix: TextWidget.label("手机号").tight(width: 100.w),
        controller: controller.phoneController,
        placeholder: "请输入手机号",
        keyboardType: TextInputType.phone,
        border: Border.all(color: Colors.transparent),
      ),

      InputWidget(
        prefix: TextWidget.label("验证码").tight(width: 100.w),
        suffix: TextWidget.muted("获取验证码"),
        controller: controller.codeController,
        placeholder: "请输入验证码",
        keyboardType: TextInputType.phone,
        border: Border.all(color: Colors.transparent),
      ),

      InputWidget(
        prefix: TextWidget.label("设置登录密码").tight(width: 100.w),
        controller: controller.passwordController,
        placeholder: "请输入手机号",
        keyboardType: TextInputType.phone,
        border: Border.all(color: Colors.transparent),
      ),

      InputWidget(
        prefix: TextWidget.label("再次确认密码").tight(width: 100.w),
        controller: controller.confirmPasswordController,
        placeholder: "请再次确认密码",
        keyboardType: TextInputType.phone,
        border: Border.all(color: Colors.transparent),
      ),

      Spacer(),

      ButtonWidget.primary(
        "下一步",
        onTap: controller.onTap,
      ).paddingHorizontal(AppSpace.page),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterIndexController>(
      init: RegisterIndexController(),
      id: "register_index",
      builder: (_) {
        return Scaffold(
          appBar: AppBarWidget(title: "注册账号"),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
