import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youmeet/common/index.dart';
import 'package:youmeet/common/services/upload.dart';

class RegisterIndexController extends GetxController {
  RegisterIndexController();

  String get currentLanguage =>
      ConfigService.to.locale.languageCode == 'zh' ? "中文" : "English";

  final phoneController = TextEditingController();

  final verifyCodeController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final nikenameController = TextEditingController();
  final nikenameFocusNode = FocusNode();

  final birthController = TextEditingController();
  final birthFocusNode = FocusNode();

  final ImagePicker _picker = ImagePicker();

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

  // 注册请求参数
  UserRegisterReq req = UserRegisterReq(sex: 1);

  bool isRegisterEnabled = false;

  /// 是否同意隐私政策
  bool isAgreePrivacy = false;

  /// 是否隐藏获取验证码
  bool hideVerifyCode = false;

  /// 获取验证码
  void gerVerifyCode() {
    logger.d("获取验证码");
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
    Get.toNamed(RouteNames.systemRegisterSelectLanguage);
  }

  void onCountryCodeChanged(String value) {
    logger.d("选择国家区号: $value");
  }

  /// 更新下一步按钮状态
  void updateButtonState() {
    isRegisterEnabled =
        phoneController.text.isNotEmpty &&
        verifyCodeController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text;
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

  //portrait
  /// 更新性别
  void updateGender(int i) {
    req.sex = i;
    update(["gender"]);
  }

  // 注册
  void onRegister() async {
    req.account = phoneController.text;
    req.password = passwordController.text;
    req.name = nikenameController.text;
    req.birthday = birthController.text;
    req.country = countryModel.chinese;
    req.phoneAreaCode = countryModel.phone;
    req.shortEn = countryModel.shortEn;
    req.zoneId = countryModel.zoneId;

    if(req.name?.isEmpty == true){
      Loading.error("请输入昵称");
      return;
    }


    if(req.realPic?.isEmpty == true) {
      Loading.error("请上传实名认证照片");
      return;
    }

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

  // 选择单张图片
  void pickImage(String type) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        await UploadService.to.requestQiniuToken();

        UploadService.to.upload(
          pickedFile.path,
          onProgress: (progress) {},
          onStatus: (state) {},
          onDone: (done) {
            logger.d('上传完成: ${done.key}');
            switch (type) {
              case Constants.avatar:
                req.portrait = "t.pic.mooneyu.com/${done.key}";
                update(["register_basic_information"]);
                break;
              case Constants.realPic:
                req.realPic = "t.pic.mooneyu.com/${done.key}";
                update(["register_upload_picture"]);
                break;
              default:
            }
          },
        );
      }
    } catch (e) {
      logger.d('选择图片失败: $e');
      Get.snackbar('错误', '选择图片失败，请检查权限设置');
    }
  }
}
