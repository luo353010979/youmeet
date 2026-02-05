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

  CountryModel countryModel = CountryModel(
    id: "1",
    createBy: "",
    createTime: "2024-06-27 19:37:45",
    updateBy: "admin",
    updateTime: "2025-07-10 09:59:09",
    chinese: "中国",
    english: "China",
    phone: "86",
    shortEn: "CN",
    nationalFlag: "t.pic.mooneyu.com/Fl8tUQVplOCS6zxCw21UiGgDXhkF",
    zoneId: "Asia/Shanghai",
    appKey: null,
  );

  String avatarUri = "";

  int gender = 1;

  bool isRegisterEnabled = false;

  /// 是否同意隐私政策
  bool isAgreePrivacy = false;

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
      countryModel = result;
      if (countryModel.phone == '86') {
        hideVerifyCode = false;
      } else {
        hideVerifyCode = true;
      }
      update(["form"]);
    }
  }

  /// 更新性别
  void updateGender(int i) {
    gender = i ;
    update(["gender"]);
  }

  void onRegister() async {
    UserRegisterReq req = UserRegisterReq(
      account: phoneController.text,
      password: passwordController.text,
      name: nikenameController.text,
      birthday: birthController.text,
      country: countryModel.chinese,
      phoneAreaCode: countryModel.phone,
      sex: gender,
      shortEn: countryModel.shortEn,
      zoneId: countryModel.zoneId,
    );
    final isRegister = await UserService.to.register(req);
    if (isRegister) {
      Get.offAllNamed(RouteNames.systemMain);
    }
  }

  @override
  void onClose() {
    super.onClose();
    phoneController.dispose();
    verifyCodeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nikenameController.dispose();
    nikenameFocusNode.dispose();
    birthController.dispose();
    birthFocusNode.dispose();
  }

  /// 更新隐私政策同意状态
  void updateAgreePrivacy(bool? value) {
    isAgreePrivacy = value ?? false;
    update(["privacy"]);
  }
}
