import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class LoginController extends GetxController {
  LoginController();

  // 用户名
  TextEditingController usernameController = TextEditingController();

  // 密码
  TextEditingController passwordController = TextEditingController();

  bool isLoginEnabled = false;

  void onLogin() {
    Get.offAllNamed(RouteNames.systemMain);
  }

  void onRegister() {
    Get.toNamed(RouteNames.systemRegisterRegisterIndex);
  }

  void updateButtonState() {
    // 检查用户名和密码是否都不为空
    isLoginEnabled =
        usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
    update(["login_btn"]);
  }

  @override
  void onClose() {
    super.onClose();
    usernameController.dispose();
    passwordController.dispose();
  }
}
