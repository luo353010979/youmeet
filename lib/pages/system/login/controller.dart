import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class LoginController extends GetxController {
  LoginController();

  // 用户名
  TextEditingController usernameController = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();

  // 密码
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();

  bool isLoginEnabled = false;
  bool isPasswordHidden = true; // 密码是否隐藏

  @override
  void onInit() {
    super.onInit();
    _loadCachedCredentials();
  }

  /// 读取缓存的账号密码并回填
  void _loadCachedCredentials() {
    final account = Storage().getString(Constants.storageAccount);
    final password = EncryptUtil().aesDecode(
      Storage().getString(Constants.storagePassword),
    );
    if (account.isNotEmpty) usernameController.text = account;
    if (password.isNotEmpty) passwordController.text = password;
    updateButtonState();
  }

  /// 保存账号密码（切换账号时自动覆盖旧的）
  void _saveCredentials() {
    Storage().setString(Constants.storageAccount, usernameController.text);
    Storage().setString(
      Constants.storagePassword,
      EncryptUtil().aesEncode(passwordController.text),
    );
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
      _saveCredentials();
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
