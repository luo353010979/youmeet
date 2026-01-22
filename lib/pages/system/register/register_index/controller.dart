import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterIndexController extends GetxController {
  RegisterIndexController();

  final phoneController = TextEditingController();

  final codeController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool isRegisterEnabled = false;

  /// 获取验证码
  void gerVerifyCode() {
    print("获取验证码");
  }

  /// 下一步
  void onNextStep() {
    print("下一步");
  }

  void selectLanguage() {
    print("选择语言");
  }

  /// 更新下一步按钮状态
  void updateButtonState() {
    isRegisterEnabled =
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        codeController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
    update(["register_btn"]);
  }

  @override
  void onClose() {
    super.onClose();
    phoneController.dispose();
    codeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
