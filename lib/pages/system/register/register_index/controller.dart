import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class RegisterIndexController extends GetxController {
  RegisterIndexController();

  final phoneController = TextEditingController();

  final verifyCodeController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final nikenameController = TextEditingController();
  final nikenameFocusNode = FocusNode();

  final birthController = TextEditingController();
  final birthFocusNode = FocusNode();

  String avatarUri = "";

  int gender = 0;

  bool isRegisterEnabled = false;

  /// 是否同意隐私政策
  bool isAgreePrivacy = false;

  /// 国家区号图片
  String countryCode = '86';
  String countryImageUrl =
      "http://t.pic.mooneyu.com/Fl8tUQVplOCS6zxCw21UiGgDXhkF";

  /// 是否隐藏获取验证码
  bool hideVerifyCode = false;

  /// 获取验证码
  void gerVerifyCode() {
    print("获取验证码");
  }

  /// 下一步
  void onNextStep() {
    if (isAgreePrivacy == false) {
      Loading.error("请同意隐私政策");
      return;
    }
    Get.toNamed(RouteNames.systemRegisterRegisterBasicInformation);
  }

  void selectLanguage() {
    print("选择语言");
  }

  void onCountryCodeChanged(String value) {
    print("选择国家区号: $value");
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

  /// 跳转选择国家页面
  void toSelectCountryPage() async {
    final result = await Get.toNamed(RouteNames.systemRegisterSelectCountry);
    if (result != null && result is CountryModel) {
      countryCode = result.phone ?? countryCode;
      countryImageUrl = "http://${result.nationalFlag}";
      if (countryCode == '86') {
        hideVerifyCode = false;
      } else {
        hideVerifyCode = true;
      }
      update(["form"]);
    }
  }

  @override
  void onClose() {
    super.onClose();
    phoneController.dispose();
    verifyCodeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void updateAgreePrivacy(bool? value) {
    isAgreePrivacy = value ?? false;
    update(["privacy"]);
  }

  void updateGender(int i) {
    gender = i;
    update(["gender"]);
  }
}
