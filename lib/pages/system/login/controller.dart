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
  bool isPasswordHidden = true; // 密码是否隐藏

  @override
  void onInit() {
    super.onInit();
  }

  void clearUsername() {
    usernameController.clear();
    update(["form"]);
  }

  void clearPassword() {
    passwordController.clear();
    update(["form"]);
  }

  void hidePwd() {
    isPasswordHidden = !isPasswordHidden;
    update(["form"]);
  }

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
    update(["login_btn", "form"]);
  }

  @override
  void onClose() {
    super.onClose();
    usernameController.dispose();
    passwordController.dispose();
  }
}
