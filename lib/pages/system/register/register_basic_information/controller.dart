import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

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
    logger.d("选择头像");
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
