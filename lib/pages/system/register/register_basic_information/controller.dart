import 'package:get/get.dart';

class RegisterBasicInformationController extends GetxController {
  RegisterBasicInformationController();

  _initData() {
    update(["register_basic_information"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  void chooseAvatar() {
    print("选择头像");
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
