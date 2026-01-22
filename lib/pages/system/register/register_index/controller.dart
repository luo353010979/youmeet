import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class RegisterIndexController extends GetxController {
  RegisterIndexController();

  final phoneController = TextEditingController();

  final verifyCodeController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool isRegisterEnabled = false;

  /// 获取验证码
  void gerVerifyCode() {
    print("获取验证码");
  }

  /// 下一步
  void onNextStep() {
    Get.toNamed(RouteNames.systemRegisterRegisterBasicInformation);
  }

  void selectLanguage() {
    print("选择语言");
  }

  /// 更新下一步按钮状态
  void updateButtonState() {
    isRegisterEnabled =
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        verifyCodeController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
    update(["register_btn"]);
  }

  @override
  void onClose() {
    super.onClose();
    phoneController.dispose();
    verifyCodeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
