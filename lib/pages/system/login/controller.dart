import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class LoginController extends GetxController {
  LoginController();

  // 用户名
  TextEditingController usernameController = TextEditingController(
    text: "17345939400",
  );
  FocusNode usernameFocusNode = FocusNode();

  // 密码
  TextEditingController passwordController = TextEditingController(
    text: "353010",
  );
  FocusNode passwordFocusNode = FocusNode();

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

  /// 登录
  void onLogin() async {
    UserLoginReq loginReq = UserLoginReq(
      account: usernameController.text,
      password: passwordController.text,
    );

    bool isLogin = await UserService.to.login(loginReq);
    if (isLogin) {
      Get.offAllNamed(RouteNames.systemMain);
    }
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
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
  }
}
